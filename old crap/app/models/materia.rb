# -*- encoding : utf-8 -*-
class Materia < ActiveRecord::Base
	set_primary_key :id
	def secciones
		Seccion.where(:materia_id => id)
	end

	has_many :seccion

  def entregas
    EntregaSeccion.where(:materia_id => id).collect{|x|
      x.entrega
    }.uniq
  end

  def docentes
    DocenteMateria.where(:materia_id => id).collect{|x| x.docente}
  end
end