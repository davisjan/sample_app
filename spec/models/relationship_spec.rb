# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Relationship do
  before :each do
    @follower = Factory :user
    @followed = Factory(:user, :email => Factory.next(:email))
    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end
  it "should create a new instance given valid attributes" do
    @relationship.save!
  end

  describe "validations" do
    it "should require a follower id" do
      @relationship.follower_id = nil
      @relationship.should_not be_valid
    end
    it "should require a followed id" do
      @relationship.followed_id = nil
      @relationship.should_not be_valid
    end
  end
end
