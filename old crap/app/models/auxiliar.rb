# -*- encoding : utf-8 -*-
class Auxiliar < ActiveRecord::Base
	set_primary_key :usuario_cedula

	belongs_to :usuario

	def contribuyentes
		ContribuyenteAuxiliar.where(:auxiliar_cedula => usuario_cedula).collect{|x| x.contribuyente }
	end

	/def nombres
		Usuario.where(:cedula => usuario_cedula).first.nombres
		#usuario.nombres
	end

	def nombreCompleto
		nombre = Usuario.where(:cedula => usuario_cedula).first.nombres
		apelildo = Usuario.where(:cedula => usuario_cedula).first.apellidos
		"#{nombre} #{apellido}"
	end/
end