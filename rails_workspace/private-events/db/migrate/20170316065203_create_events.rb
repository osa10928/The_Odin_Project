class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :place
      t.date :day
      t.text :desc

      t.timestamps
    end
  end
end
