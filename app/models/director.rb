# -*- encoding : utf-8 -*-
class Director < ActiveRecord::Base
	set_primary_key :usuario_cedula

	belongs_to :usuario
end
