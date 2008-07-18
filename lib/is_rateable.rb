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
      
      ActionController::Routing::Routes.add_route('/:controller/:id/rate/:rating', :action => 'rate', :method => :put)
    end
  end

  module InstanceMethods
    def rating
      if (rating = Rating.average(:value))
        rating.round
      else
        0
      end
    end
    
    def rating_range
      0..self.maximum_rating_allowed
    end
    
    def add_rating(value)
      self.ratings.create!(:value => value)
    end
    
    def rating_in_words
      case self.rating
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
    # polymorphic url sucks big time. unfortunately I ended up having to create a method to do this.
    def rating_url(record, value)
      url_for :controller => record.class.to_s.downcase.pluralize, :id => record.to_param, :action => "rate", :rating => value, :method => :put
    end
    
    def render_rating(record, type=:simple, units="star")
      units = units.pluralize unless record.rating == 1
      
      case type
      when :simple
        "#{record.rating}/#{record.maximum_rating_allowed} #{units}"
      when :interactive_stars
        content_tag(:ul, :class =>  "rating #{record.rating_in_words}star") do
          content_tag(:li, content_tag(:a, "1", :href => rating_url(record, 1), :title => "Rate this 1 #{units} out of #{record.maximum_rating_allowed}"), :class => "one") +
          content_tag(:li, content_tag(:a, "2", :href => rating_url(record, 2), :title => "Rate this 2 #{units} out of #{record.maximum_rating_allowed}"), :class => "two") +
          content_tag(:li, content_tag(:a, "3", :href => rating_url(record, 3), :title => "Rate this 3 #{units} out of #{record.maximum_rating_allowed}"), :class => "three") +
          content_tag(:li, content_tag(:a, "4", :href => rating_url(record, 4), :title => "Rate this 4 #{units} out of #{record.maximum_rating_allowed}"), :class => "four") +
          content_tag(:li, content_tag(:a, "5", :href => rating_url(record, 5), :title => "Rate this 5 #{units} out of #{record.maximum_rating_allowed}"), :class => "five")
        end
      end
    end
  end
end
