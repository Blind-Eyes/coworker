# -*- encoding : utf-8 -*-
class CreateDocentes < ActiveRecord::Migration
  def change
    create_table :docentes do |t|

      t.timestamps
    end
  end
end
