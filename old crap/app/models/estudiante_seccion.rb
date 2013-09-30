# -*- encoding : utf-8 -*-
class EstudianteSeccion < ActiveRecord::Base
	set_primary_keys :estudiante_cedula, :seccion_id, :materia_id

	belongs_to :materia 
	belongs_to :seccion
	belongs_to :estudiante , :foreign_key => :estudiante_cedula

	def self.estudiantes(materia, nombreSeccion)
		@cedulas = EstudianteSeccion.where(:materia_id => materia, :seccion_nombre => nombreSeccion).order("rand()")
		return @cedulas
	end

	def self.estudiantes(materia)
		@cedulas = EstudianteSeccion.where(:materia_id => materia).order("rand()")
		return @cedulas
	end
end 
