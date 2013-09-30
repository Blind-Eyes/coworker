# -*- encoding : utf-8 -*-
class Seccion < ActiveRecord::Base
	set_primary_keys :id, :materia_id

#	def materia
#		Materia.where(:id => materia_id).first
#	end

	belongs_to :materia 

end
