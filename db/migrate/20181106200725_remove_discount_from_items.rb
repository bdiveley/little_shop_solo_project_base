class RemoveDiscountFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :discount
  end
end
