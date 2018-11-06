class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :first_percent, default: 0
      t.integer :second_percent, default: 0
      t.integer :first_quantity, default: 0
      t.integer :second_quantity, default: 0
      t.references :item, foreign_key: true, unique: true

      t.timestamps
    end
  end
end
