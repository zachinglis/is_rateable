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
      Rating.average(:value).round || 0
    end
    
    def rating_range
      0..self.maximum_rating_allowed
    end
    
    def add_rating(value)
      self.ratings.create!(:value => value)
    end
    
    def rating_in_words
      case object.rating
      when 0 
        "no"
      when 1
        "one"
      when 2
        "two"
      when 3
        "three"
      when 4
        "four"
      when 5
        "five"
      end      
    end
  end
  
  module ViewMethods
    def render_rating(object, type=:simple, units="star")
      units = units.pluralize unless object.rating == 1
      
      case type
      when :simple
        "#{object.rating}/#{object.maximum_rating_allowed} #{units}"
      when :interactive_stars
        raise "Cannot have any other number than 5 #{units} for the interactive_stars type. You have #{object.maximum_rating_allowed}" unless object.maximum_rating_allowed == 5
        content_tag(:ul, :class =>  "rating #{object.rating_in_words}star") do
          content_tag(:li, content_tag(:a, "1", :href => "#", :title => "Rate this 1 #{units} out of #{object.maximum_rating_allowed}"), :class => "one") +
          content_tag(:li, content_tag(:a, "2", :href => "#", :title => "Rate this 2 #{units} out of #{object.maximum_rating_allowed}"), :class => "two") +
          content_tag(:li, content_tag(:a, "3", :href => "#", :title => "Rate this 3 #{units} out of #{object.maximum_rating_allowed}"), :class => "three") +
          content_tag(:li, content_tag(:a, "4", :href => "#", :title => "Rate this 4 #{units} out of #{object.maximum_rating_allowed}"), :class => "four") +
          content_tag(:li, content_tag(:a, "5", :href => "#", :title => "Rate this 5 #{units} out of #{object.maximum_rating_allowed}"), :class => "five")
        end
      end
    end
  end
end
