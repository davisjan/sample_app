require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory :user
    visit edit_user_path user
    # Follow redirect to login page
    fill_in :email,	:with => user.email
    fill_in :password,	:with => user.password
    click_button
    # After logging in, we should arrive at the edit page
    response.should render_template 'users/edit'
  end
end
