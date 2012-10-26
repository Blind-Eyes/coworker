# -*- encoding : utf-8 -*-
class CreateSeccions < ActiveRecord::Migration
  def change
    create_table :seccions do |t|

      t.timestamps
    end
  end
end
