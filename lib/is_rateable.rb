module IsRateable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    # Add this method to your model
    #
    #   is_rateable
    #
    # which specifies the maximum allowed units to be 5. To specify anything else do the following:
    #
    #   is_rateable :upto => 10
    #
    def is_rateable(options={})
      include InstanceMethods
      has_many :ratings, :as => :rateable
      
      cattr_accessor :minimum_rating_allowed, :maximum_rating_allowed
      self.minimum_rating_allowed = options[:from] || 1
      self.maximum_rating_allowed = options[:upto] || 5
      
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
    
    def rate(value, options={})
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
      url_for :controller => record.class.to_s.downcase.pluralize, :id => record.to_param, :action => "rate", :rating => value
    end

    def render_rating(record, type=:simple, units="star")
      case type
      when :simple
        "#{record.rating}/#{record.maximum_rating_allowed} #{pluralize(record.rating, units)}"
      when :interactive_stars
        content_tag(:ul, :class =>  "rating #{record.rating_in_words}star") do
          (record.minimum_rating_allowed..record.maximum_rating_allowed).map do |i|
            content_tag(:li, link_to(i, rating_url(record, i), :title => "Rate this #{pluralize(i, units)} out of #{record.maximum_rating_allowed}", :method => :put), :class => "rating-#{i}")
          end.join("\n")
        end
      end
    end
  end
end
