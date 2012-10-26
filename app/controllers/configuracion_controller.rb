# -*- encoding : utf-8 -*-
class ConfiguracionController < ApplicationController
	
	before_filter :verificar_autenticado

	def index
		@titulo_pagina = "Modulo de Administracion"
		bitacora "#{session[:usuario].descripcion} ingreso al modulo de administracion"	
	end

	def listarDocentes
		@titulo_pagina = "Administrador - Docentes"
		bitacora "#{session[:usuario].descripcion} ingreso a la seccion de docentes del administrador"
		@docentes = Docente.all
	end

	def verMaterias
		@titulo_pagina = "Administrador - Materias"
		bitacora "#{session[:usuario].descripcion} ingreso a la seccion de materias del administrador"
		@docenteCedula = params[:docente_cedula]
		@docente = Docente.find(@docenteCedula)
	end

	def agregarDocente
		@titulo_pagina = "Administrador - Agregar Docente"
		bitacora "#{session[:usuario].descripcion} ingreso a la seccion de agregar docentes del administrador"
		@materiaid = params[:materia_id]
		@seleccionado = Materia.find(params[:materia_id])
		@docente = Docente.all
	end

	def eliminarDocente
		@titulo_pagina = "Administrador - Eliminar Docentes"
		bitacora "#{session[:usuario].descripcion} ingreso a la seccion de eliminar docentes del administrador"
		@materiaid = params[:materia_id]
		@seleccionado = Materia.find(params[:materia_id])
		@docente = Docente.all
	end

	def deleteMateria
		@titulo_pagina = "Administrador - Eliminar Materia"
		
		@docenteCedula = params[:docente_cedula]
		@materiaid  = params[:materia_id]
		bitacora "#{session[:usuario].descripcion} borro al docente "+@docenteCedula.to_s+" de la materia "+@materiaid.to_s
		DocenteMateria.find(:first, :conditions => { :docente_cedula => @docenteCedula, :materia_id => @materiaid}).destroy

    	flash[:mensaje] = "Se ha eliminado la materia "+@materiaid.to_s+" dictada por "+@docenteCedula.to_s
		redirect_to :action => "index"
	end

	def procesar_eliminar_docente
		@materia_id = params[:materia_id]
		@cedula = params[:usuario][:cedula]

		if DocenteMateria.find(:first, :conditions => { :docente_cedula => @cedula, :materia_id => @materia_id})
			DocenteMateria.find(:first, :conditions => { :docente_cedula => @cedula, :materia_id => @materia_id}).destroy
			@materia = Materia.where(:id => @materia_id)
        	@usuario = Usuario.where(:cedula => @cedula)
			EntregaMailer.notificar_docente_eliminar(@usuario,@materia).deliver
			bitacora "#{session[:usuario].descripcion} elimino al usuario "+Usuario.where(:cedula => @cedula).first.nombre_completo+" de la materia "+Materia.where(:id => @materia_id).first.nombre
			flash[:mensaje] = "El usuario "+Usuario.where(:cedula => @cedula).first.nombre_completo+" fue eliminado la materia "+Materia.where(:id => @materia_id).first.nombre
		else 
			flash[:mensaje] = "El usuario "+Usuario.where(:cedula => @cedula).first.nombre_completo+" no dicta la materia "+Materia.where(:id => @materia_id).first.nombre
		end
		redirect_to :action => "index"

	end

	def agregarMateria
		@titulo_pagina = "Administrador - Agregar Materias"
		bitacora "#{session[:usuario].descripcion} ingreso a la seccion de agregar materias del administrador"
		@docenteCedula = params[:docente_cedula]
		@materias = Materia.all
	end

   	def procesar_agregar_docente
		@materia_id = params[:materia_id]
		@cedula = params[:usuario][:cedula]
		@docenteMateria= DocenteMateria.new
		@docenteMateria.docente_cedula = @cedula
		@docenteMateria.materia_id = @materia_id
		if @docenteMateria.save
			@materia = Materia.where(:id => @docenteMateria.materia_id)
        	@usuario = Usuario.where(:cedula => @docenteMateria.docente_cedula)
        	EntregaMailer.notificar_docente_asignacion(@usuario,@materia).deliver
        	bitacora "#{session[:usuario].descripcion} agrego al docente " + Usuario.where(:cedula => @docenteMateria.docente_cedula).first.nombre_completo + " a la materia " + @materia_id.to_s
	    	flash[:mensaje] = "El Docente " + Usuario.where(:cedula => @docenteMateria.docente_cedula).first.nombre_completo + " se ha agregado exitosamente"
	    	redirect_to :action => "index"
      	else
      		flash[:mensaje] = "Ha ocurrido un error al agregar al docente a la materia"
   			redirect_to :action => "index"
      	end
	   	rescue ActiveRecord::RecordNotUnique
	   		flash[:mensaje] = "Este docente ya esta dictando esta materia"
	   		redirect_to :action => "listarMaterias"
   	end

   	def procesar_agregar_materia
		@docenteCedula = params[:docente_cedula]
		@docenteMateria= DocenteMateria.new
		@docenteMateria.docente_cedula = @docenteCedula
		@docenteMateria.materia_id = params[:materia][:id]
		if @docenteMateria.save
		  	@materia = Materia.where(:id => @docenteMateria.materia_id)
          	@usuario = Usuario.where(:cedula => @docenteCedula)
          	#EntregaMailer.notificar_docente_materia(@usuario,@materia).deliver
          	bitacora "#{session[:usuario].descripcion} agrego la materia " + Materia.where(:id => @docenteMateria.materia_id).first.nombre + " al docente " + Usuario.where(:cedula => @docenteCedula).first.nombre_completo
	      	flash[:mensaje] = "La materia " + Materia.where(:id => @docenteMateria.materia_id).first.nombre + " se ha agregado exitosamente"
	      	redirect_to :action => "index"
      	else
      		flash[:mensaje] = "Ha ocurrido un error al agregar la materia"
   			redirect_to :action => "index"
      	end
		rescue ActiveRecord::RecordNotUnique
			flash[:mensaje] = "Esta materia ya esta siendo dictada por esta persona"
			redirect_to :action => "listarDocentes"
   	end

end