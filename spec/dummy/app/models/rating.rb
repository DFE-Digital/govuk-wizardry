class Rating < ApplicationRecord
  RATINGS = { 1 => 'Dire', 2 => 'Alright', 3 => 'Average', 4 => 'Decent', 5 => 'Amazing' }.freeze

  validates :full_name,
            presence: { message: "Enter your full name" },
            on: :identification,
            length: { maximum: 30, too_long: "must be 30 characters or fewer" }

  validates :name,
            presence: { message: "Tell us how we should address you" },
            on: :identification

  validates :name_check,
            inclusion: { in: [true], message: "Please answer the questions truthfully" },
            on: :name_check

  validates :are_you_sure,
            inclusion: { in: [true], message: "Enter an answer" },
            on: :are_you_sure

  validates :address_1, presence: true, on: :address
  validates :postcode, presence: true, on: :address

  def rating
    RATINGS[self[:rating]]
  end

  def finalize!
    Rails.logger.debug("object finalized #{identifier}")
  end
end
