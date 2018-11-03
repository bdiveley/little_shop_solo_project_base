require "rails_helper"

RSpec.describe 'Admin-only item management' do
  before(:each) do
    @admin = create(:admin)
    @active_user = create(:user)
    @active_merchant = create(:merchant)
    @item = create(:item)
  end
  it 'allows admin access to a an item edit page through admin namespace' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit item_path(@item)
    click_link "Edit"

    expect(current_path).to eq(edit_admin_item_path(@item))
  end

  xit "allows admin to change the all atributes, including the slug for a user" do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit edit_admin_user_path(@active_user)

    fill_in :user_name, with: "New Name"
    fill_in :user_address, with: "New Address"
    fill_in :user_city, with: "New City"
    fill_in :user_state, with: "New State"
    fill_in :user_zip, with: "New Zip"
    fill_in :user_email, with: "New Email"
    fill_in :user_slug, with: "coolnewslug"
    click_button 'Update User'

    expect(current_path).to eq('/users/coolnewslug')
    expect(page).to have_content("New Name")
    expect(page).to have_content("New Address")
    expect(page).to have_content("New City")
    expect(page).to have_content("New State")
    expect(page).to have_content("New Zip")
    expect(page).to have_content("New Email")

  end
end
