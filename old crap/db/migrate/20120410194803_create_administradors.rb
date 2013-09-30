# -*- encoding : utf-8 -*-
class CreateAdministradors < ActiveRecord::Migration
  def change
    create_table :administradors do |t|

      t.timestamps
    end
  end
end
