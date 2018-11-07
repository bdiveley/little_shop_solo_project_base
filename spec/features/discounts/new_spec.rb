require "rails_helper"

RSpec.describe 'Discount New Page, only for merchants' do
  context 'As a merchant user' do
    before(:each) do
      @merchant = create(:merchant)
      @item = @merchant.items.create(name: "Item 1", description: "Description", price: 5, inventory: 30)
      @discount = @item.discounts.create(percent_off: 5, quantity: 10)
      @discount_2 = @item.discounts.create(percent_off: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'should be able to create a new discount' do
      visit new_item_discount_path(@item)

      fill_in :discount_percent_off, with: '10'
      fill_in :discount_quantity, with: '5'
      click_button 'Create Discount'

      expect(current_path).to eq(item_discounts_path(@item))

      expect(page).to have_content("When a buyer purchases at least 5 items, the item price is discounted by 10%")
    end
  end
end
