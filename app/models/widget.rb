# == Schema Information
#
# Table name: widgets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Widget < ActiveRecord::Base
end
