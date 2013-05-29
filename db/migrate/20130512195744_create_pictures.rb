class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.datetime :date_of_shot
      t.string :author

      t.timestamps
    end
  end
end
