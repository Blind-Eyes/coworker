# -*- encoding : utf-8 -*-
class Entregable < ActiveRecord::Base
	set_primary_keys :grupo_nro, :entrega_id

  belongs_to :grupo, :foreign_key => [:grupo_nro, :entrega_id]
  belongs_to :estudiante_entrego, :foreign_key => [:estudiante_cedula_entrego], :class_name => "Estudiante"
end
