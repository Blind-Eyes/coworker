# -*- encoding : utf-8 -*-
class Estudiante < ActiveRecord::Base
	set_primary_key :usuario_cedula

	def materias
		EstudianteSeccion.where(:estudiante_cedula => usuario_cedula).collect{|x| x.materia }
	end
end
