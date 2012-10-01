# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Micropost do
  before :each do
    @attr = { :content => "value for content",
              :user_id => 1 }
  end
  it "should create a new instance" do
    Micropost.create!(@attr)
  end
end
