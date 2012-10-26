# -*- encoding : utf-8 -*-
class DocenteMateria < ActiveRecord::Base
	set_primary_keys :docente_cedula, :materia_id

	belongs_to :materia

	belongs_to :docente, :foreign_key => :docente_cedula
end
