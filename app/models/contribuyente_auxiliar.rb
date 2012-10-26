# -*- encoding : utf-8 -*-
class contribuyente_auxiliar < ActiveRecord::Base
	set_primary_keys :auxiliar_cedula, :contribuyente_id

	belongs_to :contribuyente

	belongs_to :auxiliar, :foreign_key => :auxiliar_cedula
end
