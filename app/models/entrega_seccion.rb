# -*- encoding : utf-8 -*-
class EntregaSeccion < ActiveRecord::Base
	set_primary_keys :entrega_id, :seccion_id, :materia_id

  belongs_to :entrega
end
