class AddEventsToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :events, foreign_key: true
  end
end
