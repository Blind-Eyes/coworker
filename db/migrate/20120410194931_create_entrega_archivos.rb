# -*- encoding : utf-8 -*-
class CreateEntregaArchivos < ActiveRecord::Migration
  def change
    create_table :entrega_archivos do |t|

      t.timestamps
    end
  end
end
