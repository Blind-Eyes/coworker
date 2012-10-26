# -*- encoding : utf-8 -*-
class Grupo < ActiveRecord::Base
	set_primary_keys :id, :entrega_id

	def integrantes(grupoNro,entregaId)
		EstudianteGrupo.where(:grupo_nro => grupoNro,:entrega_id => entregaId)
	end
end