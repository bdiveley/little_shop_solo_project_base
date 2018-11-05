class AddDiscountToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :discount, :boolean, default: false
  end
end
