class RatingsController < ApplicationController
  include Wizardry

  wizard name: 'ratings',
    class_name: 'Rating',
    edit_path_helper: :ratings_page_path,
    update_path_helper: :ratings_path,
    pages: [
      Wizardry::Pages::Page.new(
        :identification,
        title: 'Who are you?',
        questions: [
          Wizardry::Questions::ShortAnswer.new(:full_name),
          Wizardry::Questions::EmailAddress.new(:name)
        ]
      ),
      Wizardry::Pages::Page.new(
        :address,
        title: 'Address',
        questions: [
          Wizardry::Questions::ShortAnswer.new(:address_1),
          Wizardry::Questions::ShortAnswer.new(:address_2),
          Wizardry::Questions::ShortAnswer.new(:town),
          Wizardry::Questions::ShortAnswer.new(:postcode),
        ]
      ),
      Wizardry::Pages::Page.new(
        :contact_details,
        title: 'Contact details',
        questions: [
          Wizardry::Questions::TelephoneNumber.new(:phone),
          Wizardry::Questions::EmailAddress.new(:email),
        ]
      ),
      Wizardry::Pages::Page.new(
        :feedback,
        title: 'What did you think about our service?',
        questions: [
          Wizardry::Questions::ShortAnswer.new(:customer_type),
          Wizardry::Questions::Date.new(:purchase_date),
          Wizardry::Questions::LongAnswer.new(:feedback),
          Wizardry::Questions::Radios.new(:rating, Rating::RATINGS)
        ]
      ),
      Wizardry::Pages::CheckYourAnswersPage.new,
    ]
end
