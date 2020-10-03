class RatingsController < ApplicationController
  include Wizardry

  wizard name: 'ratings',
    class_name: 'Rating',
    edit_path_helper: :ratings_page_path,
    update_path_helper: :ratings_path,
    pages: [
      Wizardry::Pages::QuestionPage.new(
        :identification,
        title: 'Who are you?',
        questions: [
          Wizardry::Questions::ShortAnswer.new(:full_name),
          Wizardry::Questions::EmailAddress.new(:name)
        ]
      ),
      Wizardry::Pages::QuestionPage.new(
        :address,
        title: 'Address',
        questions: [
          Wizardry::Questions::ShortAnswer.new(:address_1),
          Wizardry::Questions::ShortAnswer.new(:address_2),
          Wizardry::Questions::ShortAnswer.new(:town),
          Wizardry::Questions::ShortAnswer.new(:postcode),
        ],
        next_pages: [
          Wizardry::Routing::NextPage.new(:london_borough, proc { |o| o.town == "London" })
        ],
      ),
      Wizardry::Pages::QuestionPage.new(
        :london_borough,
        branch: true,
        title: 'Which borough of London do you live in?',
        questions: [
          Wizardry::Questions::ShortAnswer.new(:london_borough),
        ],
      ),
      Wizardry::Pages::QuestionPage.new(
        :contact_details,
        title: 'Contact details',
        questions: [
          Wizardry::Questions::TelephoneNumber.new(:phone),
          Wizardry::Questions::EmailAddress.new(:email),
        ]
      ),
      Wizardry::Pages::QuestionPage.new(
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
      Wizardry::Pages::CompletionPage.new,
    ]
end
