# -*- encoding : utf-8 -*-
class EntregaArchivo < ActiveRecord::Base
	set_primary_key :entrega_id

	validates :archivo, :presence => true
end
