# -*- encoding : utf-8 -*-
class CreateBitacoras < ActiveRecord::Migration
  def change
    create_table :bitacoras do |t|

      t.timestamps
    end
  end
end
