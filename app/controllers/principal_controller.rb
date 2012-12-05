# -*- encoding : utf-8 -*-
class PrincipalController < ApplicationController

  before_filter :verificar_autenticado

  def bienvenida
    @titulo_pagina = "Inicio"
  end

  def cerrar_sesion
    #bitacora "El usuario #{session[:usuario].descripcion} ha cerrado sesión"/
    reset_session
    redirect_to :action => "index", :controller => "inicio"
  end

  def addContribuyentes
    @titulo_pagina = "Agregar Contribuyentes"
  end

  def procesar_add_contribuyentes
    
    @contribuyente = Contribuyente.new
    @contribuyente.codigo = params[:codigo]
    if @cont = Contribuyente.where(:codigo => params[:codigo]).first
      if @cont.activo = 1
        flash[:mensaje] = "Ya la empresa activa '"+@cont.nombre.to_s+"' tiene el codigo "+@cont.codigo.to_s
        redirect_to :action => "addContribuyentes"
        return
      end
    end
    @contribuyente.nombre = params[:empresa]
    if Contribuyente.where(:rif => params[:rif]).first
      flash[:mensaje] = "El RIF '"+params[:rif]+"' ya existe en el sistema"
      redirect_to :action => "addContribuyentes"
      return
    end
    @contribuyente.rif = params[:rif]
    @contribuyente.direccion = params[:direccion]
    @contribuyente.telefono = params[:telefono]
    @contribuyente.contacto = params[:contacto]
    @contribuyente.correo = params[:email]
    @contribuyente.municipio = params[:municipio]
    @contribuyente.fecha_cierre = params[:fecha]
    @contribuyente.usuario = params[:usuario]
    @contribuyente.clave = params[:clave]
    if params[:tipoEmpresa]
      @contribuyente.tipo = params[:tipoEmpresa]
    else
      @contribuyente.tipo = "Especial"
    end
    @contribuyente.activo = "1"


    
    if @contribuyente.save
      #bitacora "El usuario #{session[:usuario].descripcion} agrego a "+@cedula.to_s+" al grupo"+@grupoNro.to_s+" de la entrega "+@entregaId.to_s
      flash[:mensajeSuccess] = "Se ha agregado el contribuyente "+@contribuyente.nombre.to_s
      redirect_to :action => "bienvenida"
    else
      flash[:mensaje] = "El RIF ya existe en el sistema"
      redirect_to :action => "addContribuyentes"
    end
    return

  end

  def contribuyentes  
    #@contribuyente = ContribuyenteAuxiliar.joins(:contribuyentes)
    @contribuyente = Contribuyente.find(:all,
            :joins => "INNER JOIN contribuyente_auxiliar ON contribuyente_auxiliar.contribuyente_id = contribuyente.id" ,
            :select => "contribuyente.*")
    @contribuyentesInactivos = Contribuyente.find(:all,
            :joins => "RIGHT OUTER JOIN contribuyente_auxiliar ON contribuyente_auxiliar.contribuyente_id != contribuyente.id" ,
            :select => "contribuyente.*")
  end













  def crear_entrega
    @titulo_pagina = "Crear entrega"
    #bitacora "El usuario #{session[:usuario].descripcion} ingreso en la seccion crear entrega del docente"
    @materias = session[:rol].materias
    #@entrega = Entrega.new
    #@entrega.nombre = "Hola"
    #@entrega.archivo_formato = "pdf"
  end

  def procesar_crear_entrega

    @titulo_pagina = "Crear entrega"
    @materias = session[:rol].materias
    
    @entrega = Entrega.new
    @entrega.nombre = params[:entrega][:nombre]
    @entrega.fecha_entrega = params[:entrega][:fecha_entrega]
    @entrega.fecha_tope = params[:entrega][:fecha_tope]
    @entrega.limite_versiones = params[:entrega][:limite_versiones]
    @entrega.archivo_formato = params[:entrega][:archivo_formato]
    @entrega.archivo_tamano_max = params[:entrega][:archivo_tamano_max]
    @entrega.numero_max_integrantes = params[:entrega][:numero_max_integrantes]

    unless params[:secciones]
      flash[:mensaje] = "No se han completado todos los campos"
      redirect_to :action => "crear_entrega"
      #@entrega.errors[:base] << "No se ha especificado la sección"
      #render :action => "crear_entrega"
      return
    end
    
    if @entrega.save

      if params["secciones"]
        params["secciones"].each{|sec|
          es = EntregaSeccion.new
          es.entrega_id = @entrega.id
          es.seccion_nombre = sec
          es.materia_id = params[:entrega_seccion][:materia_id]
          es.save!
        }
      end

      archivo = params[:entrega_archivo][:archivo]
      ea = EntregaArchivo.new
      ea.entrega_id = @entrega.id
      ea.archivo = archivo.read
      ea.tipo = archivo.content_type
      ea.nombre = archivo.original_filename
      ea.save

      #TODO: Correo de informacion de entrega
      if params[:correo]
        @entregas = EntregaSeccion.where(:entrega_id => @entrega.id)
        
        @entregas.each do |entrega|
         @estudiantes = EstudianteSeccion.where(:seccion_nombre => entrega.seccion_nombre, :materia_id => entrega.materia_id)
          @estudiantes.each do |estudiante|
            @usuario = Usuario.where(:cedula => estudiante.estudiante_cedula)        
            EntregaMailer.notificar_entrega_creacion(@usuario,@entrega, estudiante.materia_id).deliver
          end
        end

      end
      #bitacora "El usuario #{session[:usuario].descripcion} creo la entrega "+@entrega.nombre.to_s
      flash[:mensaje] = "La entrega se ha creado exitósamente"
      redirect_to :action => "docente"
      return

    end

    render :action => "crear_entrega"

  end

  def obtener_entrega
    entrega_id = params[:entrega_id]
    #bitacora "El usuario #{session[:usuario].descripcion} descargo el enunciado de  "+entrega_id
    ea = EntregaArchivo.where(:entrega_id => entrega_id).first
    send_data ea.archivo, :content_type => ea.tipo, :disposition => "attachment", :filename => ea.nombre
  end

  def obtener_entregable
    entrega_id = params[:entrega_id]
    grupo_nro = params[:grupo_nro]
    #bitacora "El usuario #{session[:usuario].descripcion} descargo el enunciado de  "+entrega_id+" del grupo "+grupo_nro
    ea = EntregableArchivo.where(:entrega_id => entrega_id, :grupo_nro => grupo_nro).first
    send_data ea.archivo, :content_type => ea.tipo, :disposition => "attachment", :filename => ea.nombre
  end

  def ajax_buscar_seccion
    materia_id = params[:materia_id]
    @secciones = Seccion.where(:materia_id => materia_id)
    render :layout => false
  end

  def cambiar_mi_clave
    @titulo_pagina = "Cambiar mi clave"
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion cambiar mi clave"
  end

  def procesar_cambiar_mi_clave
    unless params[:usuario] && 
      params[:usuario][:clave_anterior] &&
      params[:usuario][:clave] &&
      params[:usuario][:clave_confirmacion]
      flash[:mensaje] = "Faltan parámetros"
      #bitacora "Faltan parámetros procesando el cambio de clave"
      redirect_to :action => "cambiar_mi_clave"
      return
    end

    clave_anterior = params[:usuario][:clave_anterior]
    clave = params[:usuario][:clave]
    clave_confirmacion = params[:usuario][:clave_confirmacion]

    usuario = session[:usuario]

    if usuario.clave != clave_anterior
      flash[:mensaje] = "Clave anterior no coincide"
      #bitacora "Clave anterior no coincide con: #{clave_anterior}"
      redirect_to :action => "cambiar_mi_clave"
      return
    end

    if clave != clave_confirmacion
      flash[:mensaje] = "Clave nueva no coincide con la confirmación"
      #bitacora "Clave nueva no coincide con la confirmación"
      redirect_to :action => "cambiar_mi_clave"
      return
    end

    if clave == clave_anterior
      flash[:mensaje] = "Clave anterior coincide con la nueva"
      #bitacora "Clave anterior coincide con la nueva"
      redirect_to :action => "cambiar_mi_clave"
      return
    end

    if clave.size <= 5
      flash[:mensaje] = "Clave nueva muy corta"
      #bitacora "Clave nueva muy corta"
      redirect_to :action => "cambiar_mi_clave"
      return
    end

    usuario.clave = clave
    usuario.save
    session[:usuario] = usuario

    flash[:mensaje] = "Clave cambiada exitósamente"
    #bitacora "Clave cambiada exitósamente"
    redirect_to :action => "bienvenida"
    return

  end

  def agregar_estudiantes
    @titulo_pagina = "Agregar Estudiantes"
    @materia_nombre = params[:materia_nombre]
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion agregar estudiantes de la materia "+@materia_nombre.to_s
    @materiaId = Materia.where(:nombre => @materia_nombre).first.id
  end

  def consultar_estudiantes
    @titulo_pagina = "Consultar Estudiantes"
    @materia = Materia.where(:id => params[:materia_id]).first
    @estudiantes = EstudianteSeccion.where(:materia_id => params[:materia_id])
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion consultar estudiantes de la materia "+@materia.nombre.to_s
  end

  def procesar_agregar_estudiantes
    archivo = params[:archivo][:excel]
    @materiaId = params[:materia_id]
    ruta = Rails.root.join('excel', archivo.original_filename).to_s
    File.open(ruta, 'wb') do |file|
      file.write(archivo.read)
    end

    seccion = Procesador.analizar_excel(@materiaId, ruta)
    #bitacora "El usuario #{session[:usuario].descripcion} agrego a los estudiantes de la materia "+@materiaId.to_s
    flash[:mensaje] = "Se han agregado los estudiantes de manera exitosa"
    redirect_to :action => "docente"
  end

  def administrar_entrega
    @materias = session[:rol].materias
    @entrega = Entrega.find(params[:entrega_id])
    @materia_id = params[:materia_id]
    #bitacora "El usuario #{session[:usuario].descripcion} entro a la seccion administrar entrega de la materia "+@materia_id.to_s
    @secciones = Seccion.where(:materia_id => @materia_id)
  end

  def procesar_actualizar_entrega

    @entrega = Entrega.find(params[:entrega][:id])
    @entrega.nombre = params[:entrega][:nombre]
    @entrega.fecha_entrega = params[:entrega][:fecha_entrega]
    @entrega.fecha_tope = params[:entrega][:fecha_tope]
    @entrega.limite_versiones = params[:entrega][:limite_versiones]
    @entrega.archivo_formato = params[:entrega][:archivo_formato]
    @entrega.archivo_tamano_max = params[:entrega][:archivo_tamano_max]
    @entrega.numero_max_integrantes = params[:entrega][:numero_max_integrantes]
    @materia_id = params[:entrega_seccion][:materia_id]


    if @entrega.save
      archivo = params[:entrega_archivo][:archivo]
      
      if archivo
        @existeArchivo = EntregaArchivo.where(:entrega_id => @entrega.id).first
        if @existeArchivo
          @existeArchivo.destroy
        end

        ea = EntregaArchivo.new
        ea.entrega_id = @entrega.id
        ea.archivo = archivo.read
        ea.tipo = archivo.content_type
        ea.nombre = archivo.original_filename
        ea.save

      end

      #bitacora "El usuario #{session[:usuario].descripcion} actualizo la entrega "+@entrega.nombre.to_s
      flash[:mensaje] = "La entrega se ha actualizado exitósamente"
      

      if params[:correo]
        flash[:mensaje] = "correo"

      @entregas = EntregaSeccion.where(:entrega_id => @entrega.id)
      #TODO: Correo de informacion de entrega
        @entregas.each do |entrega|
         @estudiantes = EstudianteSeccion.where(:seccion_nombre => entrega.seccion_nombre, :materia_id => entrega.materia_id)
          @estudiantes.each do |estudiante|
            @usuario = Usuario.where(:cedula => estudiante.estudiante_cedula).first        
            EntregaMailer.notificar_estudiante_cambio(@usuario,@entrega, @materia_id).deliver
          end
        end
      end

      redirect_to :action => "docente"

    else
      
    end
  end

  def eliminar_entrega
     @entregaId = params[:entrega_id]
     @entrega = Entrega.where(:id => @entregaId).first
     @materiaId = EntregaSeccion.where(:entrega_id => @entregaId).first.materia_id
     @entregas = EntregaSeccion.where(:entrega_id => @entrega.id)

     @entregas.each do |entrega|
      @estudiantes = EstudianteSeccion.where(:seccion_nombre => entrega.seccion_nombre, :materia_id => entrega.materia_id)
      @estudiantes.each do |estudiante|
        @usuario = Usuario.where(:cedula => estudiante.estudiante_cedula).first    #    
        EntregaMailer.notificar_entrega_eliminada(@usuario,@entregaId, @materiaId).deliver
      end
    end

     @entrega.destroy
     #bitacora "El usuario #{session[:usuario].descripcion} elimino la entrega "+@entrega.nombre.to_s
     flash[:mensaje] = "Se ha eliminado la entrega"

     redirect_to :action =>"docente"
    
     
   end

  def administrar_grupos

    @materiaId = params[:materia_id]
    @materia = Materia.where(:id => params[:materia_id]).first
    @nroIntegrantes = params[:max_integrantes].to_i
    @secciones = Seccion.where(:materia_id => @materiaId)
    @entregaId = params[:entrega_id]
    @entrega = Entrega.where(:id => @entregaId).first
    @creacionFlag = EstudianteGrupo.where(:entrega_id => @entregaId).empty?
    @grupos = Grupo.where(:entrega_id => @entregaId)
    @cantEstudiantes = EstudianteSeccion.estudiantes(@materiaId).length
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion administrar grupos de la entrega "+@entrega.nombre.to_s+" de la materia "+@materia.nombre.to_s
  end

  def listar_entregables

   
    @materiaId = params[:materia_id]
    @materia = Materia.where(:id => params[:materia_id]).first
    @secciones = Seccion.where(:materia_id => @materiaId)
    @entregaId = params[:entrega_id]
    @entrega = Entrega.where(:id => @entregaId).first
    @creacionFlag = EstudianteGrupo.where(:entrega_id => @entregaId).empty?
    @grupos = Grupo.where(:entrega_id => @entregaId)
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion listar entregables de la entrega "+@entrega.nombre.to_s+" de la materia "+@materia.nombre.to_s

  end

  def crear_grupos  

    @materiaId = params[:materia_id]
    @nroIntegrantes = params[:max_integrantes].to_i
    @secciones = Seccion.where(:materia_id => @materiaId)
    @entrega_id = params[:entrega_id]
    @contador = 1
    @j = 1
    @contadorGrupos = 1
    @cantEstudiantes = EstudianteSeccion.estudiantes(@materiaId).length
    @cantGrupos = @cantEstudiantes / @nroIntegrantes.to_f
    @cantGrupos = @cantGrupos.ceil

    (1..@cantGrupos).each do |i|
          grupo = Grupo.new
          grupo.nro = @contadorGrupos
          grupo.entrega_id = @entrega_id
          grupo.save

          @contadorGrupos =  @contadorGrupos + 1
    end

    @estudiantes = EstudianteSeccion.estudiantes(@materiaId)

    @estudiantes.each do |estudiante|

      eg = EstudianteGrupo.new
      eg.estudiante_cedula = estudiante.estudiante_cedula
      eg.grupo_nro = @j
      eg.entrega_id = @entrega_id
      eg.save  

      if @contador == @nroIntegrantes
          @contador = 1
          @j = @j + 1
      else
        @contador = @contador +1
      end
    end

    #mailer
    
    @entrega = Entrega.where(:id => @entrega_id).first
    @materia = Materia.where(:id => @materiaId).first
    @estudiantesGrupos = EstudianteGrupo.where(:entrega_id => @entrega_id).order("grupo_nro ASC")
    @estudiantes.each do |estudiante| 
      @usuario = Usuario.where(:cedula => estudiante.estudiante_cedula).first        
      EntregaMailer.notificar_grupo_creacion(@usuario, @estudiantesGrupos, @materia, @entrega).deliver
    end



    #bitacora "El usuario #{session[:usuario].descripcion} creo automaticamente grupos de la entrega "+@entrega.nombre.to_s+" de la materia "+@materia.nombre.to_s
    flash[:mensaje] = "Se ha creado los grupos de manera automatica"
    redirect_to :action => "administrar_grupos",:materia_id => @materiaId, :max_integrantes => @nroIntegrantes, :entrega_id => @entrega_id
  end

  def ver_grupos

    @entregaId = params[:entrega_id]
    @grupos = Grupo.where(:entrega_id => @entregaId)
    @materiaId = EntregaSeccion.where(:entrega_id => @entregaId).first.materia_id
    @cantEstudiantes = EstudianteSeccion.estudiantes(@materiaId).length
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion ver grupos de la entrega "+@entregaId.to_s+" de la materia "+@materiaId.to_s
  end

  def editar_grupo

    @entregaId = params[:entrega_id]
    @grupoNro = params[:grupo_nro]
    @grupo = Grupo.where(:entrega_id => @entregaId, :nro => @grupoNro).first
    @materiaId = EntregaSeccion.where(:entrega_id => @entregaId).first.materia_id

    @integrantes = @grupo.integrantes(@grupoNro, @entregaId)
    @maxIntegrantes = Entrega.where(:id => @entregaId).first.numero_max_integrantes
    @estudiantesSinGrupo = EstudianteSeccion.where('materia_id = ? AND estudiante_cedula NOT IN (select estudiante_cedula from estudiante_grupo where entrega_id = ?)',@materiaId,@entregaId)
    @cedulas = @estudiantesSinGrupo.collect{|x| x.estudiante_cedula}
    @nombresEstudiantesSG = Usuario.where(:cedula => @cedulas) #Estudiantes sin grupo
    #bitacora "El usuario #{session[:usuario].descripcion} entro en la seccion editar grupos de la entrega "+@entregaId.to_s+" de la materia "+@materiaId.to_s
  end

  def eliminar_integrante
    @entregaId = params[:entrega_id]
    @cedula = params[:cedula]
    @grupoNro = params[:grupo_nro]
    @materiaId = params[:materia_id]
    @maxIntegrantes = params[:max_integrantes]


    @estudianteGrupo = EstudianteGrupo.where(:estudiante_cedula => @cedula, :grupo_nro => @grupoNro, :entrega_id => @entregaId).first
    @estudianteGrupo.destroy
    #bitacora "El usuario #{session[:usuario].descripcion} elimino a "+@cedula.to_s+" del grupo de la entrega "+@entregaId.to_s
    flash[:mensaje] = "Se ha eliminado al integrante"
    redirect_to :action => "administrar_grupos", :materia_id => @materiaId, :max_integrantes => @maxIntegrantes, :entrega_id => @entregaId
  end

  def agregar_estudiante 
    @grupoNro = params[:grupo_nro]
    @entregaId = params[:entrega_id]
    @cedula = params[:estudiante_seccion][:estudiante_cedula]
    @materiaId = params[:materia_id]
    @maxIntegrantes = params[:max_integrantes]

    @estudianteGrupo = EstudianteGrupo.new
    @estudianteGrupo.estudiante_cedula = @cedula
    @estudianteGrupo.grupo_nro = @grupoNro
    @estudianteGrupo.entrega_id = @entregaId    

    if @cedula != ""

      if @estudianteGrupo.save
        #bitacora "El usuario #{session[:usuario].descripcion} agrego a "+@cedula.to_s+" al grupo"+@grupoNro.to_s+" de la entrega "+@entregaId.to_s
        flash[:mensaje] = "Se ha agregado el estudiante "
        redirect_to :action => "administrar_grupos", :materia_id => @materiaId, :max_integrantes => @maxIntegrantes, :entrega_id => @entregaId
        #redirect_to :action => "ver_grupos", :entrega_id => @entregaId
      end 
    else
      flash[:mensaje] = "No escogió el estudiante"
      redirect_to :action => "editar_grupo", :entrega_id => @entregaId, :grupo_nro => @grupoNro
    end
    
  end

  def consultar_entrega
    @entrega = Entrega.find(params[:entrega_id])
    @materia = Materia.find(params[:materia_id])
    @seccion = EstudianteSeccion.where(:materia_id => @materia.id, :estudiante_cedula => session[:usuario].cedula).first
    @grupoExiste = EstudianteGrupo.where(:entrega_id => @entrega.id, :estudiante_cedula => session[:usuario].cedula).empty?
    if !@grupoExiste
      @grupo = EstudianteGrupo.where(:entrega_id => @entrega.id, :estudiante_cedula => session[:usuario].cedula).first
      @integrantes = EstudianteGrupo.where(:entrega_id => @entrega.id, :grupo_nro => @grupo.grupo_nro)
      @entregableExiste = Entregable.where(:entrega_id => @entrega.id, :grupo_nro => @grupo.grupo_nro).empty?
      if !@entregableExiste
        @entregables = Entregable.where(:entrega_id => @entrega.id, :grupo_nro => @grupo.grupo_nro).first
        @descargaEntregable = EntregableArchivo.where(:entrega_id => @entrega.id, :grupo_nro => @grupo.grupo_nro)
      end
    end
    @enunciadoExiste = EntregaArchivo.where(:entrega_id => @entrega.id).empty?
    #bitacora "El usuario #{session[:usuario].descripcion} entro a la seccion consultar de la entrega "+@entrega.nombre.to_s
  end

  def subir_entregable

    @titulo_pagina = "Subir entregable"
    if params[:version] != '1'
      entregable = Entregable.find(params[:grupo_nro], params[:entrega_id])
      entregable.grupo_nro = params[:grupo_nro]
      entregable.entrega_id = params[:entrega_id]
      entregable.estudiante_cedula_entrego = session[:usuario].cedula
      entregable.fecha_hora = Time.now
      entregable.version = params[:version]

      if entregable.save
        archivo = params[:entrega_archivo][:archivo]
        ea = EntregableArchivo.find(params[:grupo_nro], params[:entrega_id])
        ea.grupo_nro = params[:grupo_nro]
        ea.entrega_id = params[:entrega_id]
        ea.archivo = archivo.read
        ea.tipo = archivo.content_type
        ea.nombre = archivo.original_filename
        ea.save

        flash[:mensaje] = "El entregable se ha subido exitosamente"
        #bitacora "El usuario #{session[:usuario].descripcion} subio un entregable a la entrega "+params[:entrega_id].to_s
        redirect_to :action => "estudiante"
        return

      end
      flash[:mensaje] = "Hubo un error al subir el entregable, inténtelo nuevamente"
      render :action => "estudiante"
      
    else
      entregable = Entregable.new
      entregable.grupo_nro = params[:grupo_nro]
      entregable.entrega_id = params[:entrega_id]
      entregable.estudiante_cedula_entrego = session[:usuario].cedula
      entregable.fecha_hora = Time.now
      entregable.version = params[:version]

      if entregable.save
        archivo = params[:entrega_archivo][:archivo]
        ea = EntregableArchivo.new
        ea.grupo_nro = params[:grupo_nro]
        ea.entrega_id = params[:entrega_id]
        ea.archivo = archivo.read
        ea.tipo = archivo.content_type
        ea.nombre = archivo.original_filename
        ea.save

        flash[:mensaje] = "El entregable se ha subido exitosamente"
        #bitacora "El usuario #{session[:usuario].descripcion} subio un entregable a la entrega "+params[:entrega_id].to_s
        redirect_to :action => "estudiante"
        return

      end
      flash[:mensaje] = "Hubo un error al subir el entregable, inténtelo nuevamente"
      render :action => "estudiante"
    end
  end
end