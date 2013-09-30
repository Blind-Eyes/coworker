# -*- encoding : utf-8 -*-
class EstudianteGrupo < ActiveRecord::Base
	set_primary_keys :estudiante_cedula, :grupo_nro, :entrega_id

	def nombreCompleto
		nombre = Usuario.where(:cedula => estudiante_cedula).first.nombres
		apellido = Usuario.where(:cedula => estudiante_cedula).first.apellidos
		"#{nombre} #{apellido}"
	end
end
