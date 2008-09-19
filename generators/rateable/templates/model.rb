# == Schema Information
#
# Table name: ratings
#
#  id            :integer(11)     not null, primary key
#  value         :integer(11)     default(0)
<% if options[:by_user] %>#  user_id       :integer(11)<% else %>#  ip            :string(255)<% end %>
#  rateable_id   :integer(11)
#  rateable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
class Rating < ActiveRecord::Base
  belongs_to                :rateable, :polymorphic => true

  validates_presence_of     :rateable_type, :rateable_id
  validates_numericality_of :value
  <% if options[:by_user] %>validates_presence_of     :user<% end %>
  validate                  :maximum_value_is_not_breached
    
  def maximum_value_is_not_breached
    errors.add('value', 'is not in the range') unless rateable.rating_range.include?(value)
  end
  
  before_save               :delete_last_rating
  
  def delete_last_rating
    if (rating = Rating.find_similar(self))
      rating.destroy
    end
  end
  
  def self.find_similar(rating)
    Rating.find(:first, :conditions => { <% if options[:by_user] %>:user_id => rating.user_id<% else %>:ip => rating.ip<% end %>,
                                         :rateable_id => rating.rateable_id, :rateable_type => rating.rateable_type })
  end
end
