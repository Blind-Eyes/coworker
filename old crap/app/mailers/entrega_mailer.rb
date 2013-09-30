class EntregaMailer < ActionMailer::Base
  default from: "from@example.com"

  def notificar_estudiante_cambio(usr,entrega,materia)
  	@usuario = usr
  	@entrega = entrega
  	@materiaId = materia
   	mail(:to => @usuario[0][:correo], :subject => "Cambio de entrega")
  end

  def notificar_docente_asignacion(usr,materia)
  	@usuario = usr
  	@materia = materia
   	mail(:to => @usuario[0][:correo], :subject => "Asignacion de materia")
  end

  def notificar_docente_eliminar(usr,materia)
  	@usuario = usr
  	@materia = materia
   	mail(:to => @usuario[0][:correo], :subject => "Eliminacion de materia")
  end

  def notificar_entrega_creacion(usr,entrega,materia)
    @usuario = usr
    @entrega = entrega
    @materiaId = materia
   mail(:to => @usuario[0][:correo], :subject => "Creacion de entrega") #TODO: arreglar los querys
  end

  def notificar_grupo_creacion(usr,estudiantesGrupos,materia,entrega)
    @usuario = usr
    @entrega = Entrega.where(:id => entrega).first
    @materia = Materia.where(:id => materia).first
    @grupos = Grupo.where(:entrega_id =>@entrega.id)

   mail(:to => @usuario.correo, :subject => "Creacion de grupos")
  end

  def notificar_entrega_eliminada(usr,entrega,materia)
    @usuario = usr
    @entrega = Entrega.where(:id => entrega).first
    @materia = Materia.where(:id => materia).first

   mail(:to => @usuario.correo, :subject => "Eliminacion de entrega")
  end
end
