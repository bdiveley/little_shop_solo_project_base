require 'rails_helper'

RSpec.describe 'Admin-only user management' do
  before(:each) do
    @admin = create(:admin)
    @active_user = create(:user)
    @inactive_user = create(:inactive_user)
    @active_merchant = create(:merchant)
  end
  it 'allows admin to disable an enabled user account' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit users_path

    within "#user-#{@active_user.id}" do
      click_button "Disable"
    end
    expect(current_path).to eq(users_path)
    within "#user-#{@active_user.id}" do
      expect(page).to_not have_button("Disable")
      expect(page).to have_button("Enable")
    end

    visit logout_path
    visit login_path
    fill_in :email, with: @active_user.email
    fill_in :password, with: @active_user.password
    click_button 'Log in'
    expect(current_path).to eq(login_path)
    expect(page).to have_content('Your account is disabled')
  end

  it 'allows admin to enable a disabled user account' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit users_path
    within "#user-#{@inactive_user.id}" do
      click_button "Enable"
    end
    expect(current_path).to eq(users_path)
    within "#user-#{@inactive_user.id}" do
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enable")
    end

    visit logout_path
    visit login_path
    fill_in :email, with: @inactive_user.email
    fill_in :password, with: @inactive_user.password
    click_button 'Log in'

    expect(current_path).to eq(profile_path)
  end

  it 'allows admin to upgrade a user to a merchant' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit users_path

    within "#user-#{@active_user.id}" do
      expect(page).to have_content("#{@active_user.email} User")
      click_button "Upgrade to Merchant"
    end
    expect(current_path).to eq(users_path)
    within "#user-#{@active_user.id}" do
      expect(page).to have_content("#{@active_user.email} Merchant")
      expect(page).to_not have_button("Upgrade to Merchant")
      expect(page).to have_button("Downgrade to User")
    end
  end

  it 'allows admin to downgrade a merchant to a user' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit users_path

    within "#user-#{@active_merchant.id}" do
      expect(page).to have_content("#{@active_merchant.email} Merchant")
      click_button "Downgrade to User"
    end
    expect(current_path).to eq(users_path)
    within "#user-#{@active_merchant.id}" do
      expect(page).to have_content("#{@active_merchant.email} User")
      expect(page).to have_button("Upgrade to Merchant")
      expect(page).to_not have_button("Downgrade to User")
    end
  end
  it 'allows admin access to a user edit page through admin namespace' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit users_path
    within "#user-#{@active_user.id}" do
      click_link "Edit"
    end

    expect(current_path).to eq(edit_admin_user_path(@active_user))

    visit user_path(@active_user)
    click_link "Edit Profile Data"

    expect(current_path).to eq(edit_admin_user_path(@active_user))

    visit merchant_path(@active_merchant)
    click_link "Edit Profile Data"

    expect(current_path).to eq(edit_admin_user_path(@active_merchant))
  end
  it "allows admin to change the all atributes, including the slug for a user" do
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
  it 'should block updating if slug is not unique' do
    user_1 = create(:user, name: "Bailey")
    user_2 = create(:user, name: "Taylor")

    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit edit_admin_user_path(user_1)

    fill_in :user_slug, with: "coolnewslug"
    click_button 'Update User'

    expect(current_path).to eq("/users/coolnewslug")

    visit edit_admin_user_path(user_2)

    fill_in :user_slug, with: "coolnewslug"
    click_button 'Update User'

    expect(current_path).to eq("/admin/users/#{user_2.slug}/edit")
    expect(page).to have_content("Slug has already been taken")

    fill_in :user_slug, with: "uniqueslug"
    click_button 'Update User'

    expect(current_path).to eq('/users/uniqueslug')
  end
  it 'should block updating if email is not unique' do
    @user_1 = create(:user, name: "Bailey", email: "bailey@gmail.com")
    @user_2 = create(:user, name: "Taylor")

    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit edit_admin_user_path(@user_2)

    fill_in :user_email, with: "bailey@gmail.com"
    click_button 'Update User'

    expect(current_path).to eq(edit_admin_user_path(@user_2))
    expect(page).to have_content("Email has already been taken")
  end
end
