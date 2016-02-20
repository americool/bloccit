class AddTopicRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :topic, index: true
    add_foreign_key :comments, :topics
  end
end
