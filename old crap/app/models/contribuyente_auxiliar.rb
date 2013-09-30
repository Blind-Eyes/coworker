# -*- encoding : utf-8 -*-
class ContribuyenteAuxiliar < ActiveRecord::Base
	set_primary_keys :auxiliar_cedula, :contribuyente_id

	belongs_to :contribuyente, :foreign_key => :contribuyente_id

	belongs_to :auxiliar, :foreign_key => :auxiliar_cedula


	def nombreCompleto(cedula)
		nombre = Usuario.where(:cedula => cedula).first.nombre
		apellido = Usuario.where(:cedula => cedula).first.apellido
		"#{nombre} #{apellido}"
	end

	def codigo(contribuyenteID)
		codigo = Contribuyente.where(:id => contribuyenteID).first.codigo
		"#{codigo}"
	end

	def rif(contribuyenteID)
		rif = Contribuyente.where(:id => contribuyenteID).first.rif
		"#{rif}"
	end

	def empresa(contribuyenteID)
		nombre = Contribuyente.where(:id => contribuyenteID).first.nombre
		"#{nombre}"
	end


end
