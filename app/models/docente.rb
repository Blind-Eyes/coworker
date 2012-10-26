# -*- encoding : utf-8 -*-
class Docente < ActiveRecord::Base
	set_primary_key :usuario_cedula

	belongs_to :usuario

	def materias
		DocenteMateria.where(:docente_cedula => usuario_cedula).collect{|x| x.materia }
	end

	def nombres
		Usuario.where(:cedula => usuario_cedula).first.nombres
		#usuario.nombres
	end

	def nombreCompleto
		nombre = Usuario.where(:cedula => usuario_cedula).first.nombres
		apellido = Usuario.where(:cedula => usuario_cedula).first.apellidos
		"#{nombre} #{apellido}"
	end
end