class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment do |t|
      t.string :equipment_code
      t.string :year
      t.string :make
      t.string :model
      t.string :usage_type
      t.integer :usage
      t.date :appraisal_date
      t.string :cei
      t.integer :usage_buffered
      t.string :uid

      t.timestamps
    end
  end
end
