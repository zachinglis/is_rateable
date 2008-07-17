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
    
    def rating_range
      0..self.maximum_rating_allowed
    end
    
    def add_rating(value)
      self.ratings.create!(:value => value)
    end
  end
  
  module ViewMethods
    def render_rating(object, type=:simple, units="stars")
      case type
      when :simple
        "#{object.rating}/#{object.maximum_rating_allowed} #{units}"
      when :stars
        content_tag(:ul) do
          object.rating_range
            content_tag :li, "1", :class => "one-star", :class => "Rate this 1 star out of 5"
        end
      end
    end
  end
end
