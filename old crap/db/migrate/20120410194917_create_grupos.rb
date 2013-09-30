# -*- encoding : utf-8 -*-
class CreateGrupos < ActiveRecord::Migration
  def change
    create_table :grupos do |t|

      t.timestamps
    end
  end
end
