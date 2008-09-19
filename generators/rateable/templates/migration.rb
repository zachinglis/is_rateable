class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings, :force => true  do |t|
      t.integer     :value, :default => 0
      <% if options[:by_user] %>t.belongs_to :user<% else %>t.string :ip<% end %>
      t.belongs_to  :rateable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
