# -*- encoding : utf-8 -*-
class CreateEntregaSeccions < ActiveRecord::Migration
  def change
    create_table :entrega_seccions do |t|

      t.timestamps
    end
  end
end
