class AddApprovedAtToReservation < ActiveRecord::Migration[5.1]
  def change
    change_table :reservations do |t|
      t.datetime :approved_at
    end
  end
end
