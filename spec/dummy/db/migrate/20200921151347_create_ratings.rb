class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.string "identifier", null: false
      t.string "last_completed_step"

      t.string "full_name"
      t.string "name"

      t.string "address_1"
      t.string "address_2"
      t.string "town"
      t.string "postcode"

      t.string "london_borough"

      t.string "phone"
      t.string "email"

      t.string "customer_type"
      t.date "purchase_date"
      t.text "feedback"
      t.integer "rating"

      t.boolean "complete"

      t.timestamps
    end
  end
end
