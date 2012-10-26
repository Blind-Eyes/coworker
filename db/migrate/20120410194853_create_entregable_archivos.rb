# -*- encoding : utf-8 -*-
class CreateEntregableArchivos < ActiveRecord::Migration
  def change
    create_table :entregable_archivos do |t|

      t.timestamps
    end
  end
end
