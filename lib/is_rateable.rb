module IsRateable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def is_rateable(options={})
      include InstanceMethods
      has_many :ratings, :as => :rateable
      
      cattr_accessor :minium_rating_allowed, :maximum_rating_allowed
      self.minimum_rating_allowed = options[:from] || 0
      self.maximum_rating_allowed = options[:upto] || 5
      
      ActionController::Routing::Routes.add_route('/:controller/:id/rate/:rating', :action => 'rate', :method => :put)
    end
  end

  module InstanceMethods
    def rating
      if (rating = ratings.average(:value))
        rating.round
      else
        0
      end
    end

    def rating_range
      minimum_rating_allowed..maximum_rating_allowed
    end
    
    def add_rating(value, options={})
      ratings.create({ :value => value }.merge(options))
    end
    
    def rating_in_words
      case rating
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
      else
        rating.to_s
      end      
    end
  end

  module ViewMethods
    # polymorphic url sucks big time. unfortunately I ended up having to create a method to do this.
    def rating_url(record, value)
      url_for :controller => record.class.to_s.downcase.pluralize, :id => record.to_param, :action => "rate", :rating => value, :method => :put
    end

    def render_rating(record, type=:simple, units="star")

      case type
      when :simple
        "#{record.rating}/#{record.maximum_rating_allowed} #{pluralize(record.rating, units)}"
      when :interactive_stars
        content_tag(:ul, :class =>  "rating #{record.rating_in_words}star") do
          (minimum_rating_allowed..maximum_rating_allowed).map do |i|
            content_tag(:li, content_tag(:a, i.to_s, :href => rating_url(record, 1), :title => "Rate this #{i.to_s} #{pluralize(i, units)} out of #{record.maximum_rating_allowed}"), :class => "rating-#{i}")
        end.join("\n")
      end
    end
  end
end
