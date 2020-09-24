class Rating < ApplicationRecord
  validates :full_name,
    presence: { message: "Enter your full name" },
    on: :identification,
    length: { maximum: 30, too_long: "must be 30 characters or fewer" }

  validates :name,
    presence: { message: "Tell us how we should address you" },
    on: :identification
end
