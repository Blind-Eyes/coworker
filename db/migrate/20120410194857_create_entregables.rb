# -*- encoding : utf-8 -*-
class CreateEntregables < ActiveRecord::Migration
  def change
    create_table :entregables do |t|

      t.timestamps
    end
  end
end
