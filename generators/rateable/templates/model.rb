# == Schema Information
#
# Table name: ratings
#
#  id            :integer(11)     not null, primary key
#  value         :integer(11)     default(0)
#  user_id       :integer(11)
#  rateable_id   :integer(11)
#  rateable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
class Rating < ActiveRecord::Base
  validates_presence_of :rateable_type, :rateable_id
  
  belongs_to :rateable, :polymorphic => true
end