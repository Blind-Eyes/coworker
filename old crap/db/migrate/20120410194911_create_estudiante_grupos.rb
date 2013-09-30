# -*- encoding : utf-8 -*-
class CreateEstudianteGrupos < ActiveRecord::Migration
  def change
    create_table :estudiante_grupos do |t|

      t.timestamps
    end
  end
end
