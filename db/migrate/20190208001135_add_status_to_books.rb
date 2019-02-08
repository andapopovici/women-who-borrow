class AddStatusToBooks < ActiveRecord::Migration[5.1]
  def change
  	change_table :books do |t|
  		t.string :status, limit: 128
  	end
  end
end
