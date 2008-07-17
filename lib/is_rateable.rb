module IsRateable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def is_rateable(options={})
      include InstanceMethods
      has_many :ratings, :as => :rateable
      
      cattr_accessor :maximum_rating_allowed
      self.maximum_rating_allowed = options[:upto] || 5
    end
  end

  module InstanceMethods
    def rating
      Rating.average(:value) || 0
    end
    
    def add_rating(value)
      self.ratings.create!(:value => value)
    end
  end
end
