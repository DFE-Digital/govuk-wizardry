# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_921_151_347) do
  create_table "ratings", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "last_completed_step"
    t.string "full_name"
    t.string "name"
    t.boolean "name_check"
    t.boolean "are_you_sure"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
