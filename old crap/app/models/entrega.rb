# -*- encoding : utf-8 -*-
class Entrega < ActiveRecord::Base

  validates :nombre, :presence => true
  validates :nombre, :length => { :minimum => 3 }

  validates :numero_max_integrantes, :presence => true

  def materia
  	idmat = EntregaSeccion.where(:entrega_id => id).first.materia_id
  	Materia.where(:id => idmat).first.nombre
  end

  def seccion
  	idsec = EntregaSeccion.where(:entrega_id => id).first.seccion_nombre
  end
end