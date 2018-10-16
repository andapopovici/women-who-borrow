class CreateBorrowings < ActiveRecord::Migration[5.1]
  def change
    create_table :borrowings do |t|
      t.integer :lender_id
      t.integer :borrower_id
      t.integer :book_id
      t.date :due_date
    end
  end
end
