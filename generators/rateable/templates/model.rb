# == Schema Information
#
# Table name: ratings
#
#  id            :integer(11)     not null, primary key
#  value         :integer(11)     default(0)
#  user_id       :integer(11)
#  ip            :string(255)
#  rateable_id   :integer(11)
#  rateable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
class Rating < ActiveRecord::Base
  validates_presence_of     :rateable_type, :rateable_id
  validates_numericality_of :value
  validate                  :maximum_value_is_not_breached
  
  def maximum_value_is_not_breached
    errors.add('value', 'is not in the range') unless self.rateable.rating_range.include?(self.value)
  end
  
  belongs_to :rateable, :polymorphic => true
end
