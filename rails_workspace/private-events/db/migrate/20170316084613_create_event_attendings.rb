class CreateEventAttendings < ActiveRecord::Migration[5.0]
  def change
    create_table :event_attendings do |t|

      t.timestamps
    end
    add_reference :event_attendings, :attendee, foreign_key: {to_table: :users}
    add_reference :event_attendings, :attended_event, foreign_key: {to_table: :events}
  end
end
