# -*- encoding : utf-8 -*-
class EntregableArchivo < ActiveRecord::Base
	set_primary_keys :grupo_nro, :entrega_id
	
	validates :archivo, :presence => true
end
