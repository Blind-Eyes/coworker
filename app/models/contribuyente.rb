# -*- encoding : utf-8 -*-
class Contribuyente < ActiveRecord::Base
	set_primary_key :id

	def asignado(contribuyenteID)
		ContribuyenteAuxiliar.where(:contribuyente_id => contribuyenteID)
	end
end