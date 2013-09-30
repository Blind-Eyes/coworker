# -*- encoding : utf-8 -*-
class CreateEntregas < ActiveRecord::Migration
  def change
    create_table :entregas do |t|

      t.timestamps
    end
  end
end
