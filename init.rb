require 'is_rateable'
ActiveRecord::Base.send :include, IsRateable
ActionView::Base.send   :include, IsRateable::ViewMethods
