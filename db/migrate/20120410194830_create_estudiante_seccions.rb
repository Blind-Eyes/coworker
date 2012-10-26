# -*- encoding : utf-8 -*-
class CreateEstudianteSeccions < ActiveRecord::Migration
  def change
    create_table :estudiante_seccions do |t|

      t.timestamps
    end
  end
end
