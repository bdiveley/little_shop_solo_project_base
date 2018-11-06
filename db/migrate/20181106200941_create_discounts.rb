class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :percent_off, default: 0
      t.integer :quantity, default: 0
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
