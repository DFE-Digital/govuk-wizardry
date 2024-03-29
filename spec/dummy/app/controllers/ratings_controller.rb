class RatingsController < ApplicationController
  include Wizardry

  wizard(
    name: 'ratings',
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
        ],
        next_pages: [
          Wizardry::Routing::NextPage.new(:name_check, proc { |o| o.full_name =~ /(John|Jane) Doe/ }, label: "Name is John or Jane Doe?"),
          Wizardry::Routing::NextPage.new(:are_you_sure, proc { |o| o.full_name == "Joe Bloggs" }, label: "Name is Joe Bloggs?"),
        ],
        pages: [
          Wizardry::Pages::QuestionPage.new(
            :name_check,
            title: 'Is that your real name?',
            questions: [
              Wizardry::Questions::Radios.new(:name_check, { true => 'Yes', false => 'No' })
            ],
          ),
          Wizardry::Pages::QuestionPage.new(
            :are_you_sure,
            title: 'Are you sure?',
            questions: [
              Wizardry::Questions::Radios.new(:are_you_sure, { true => 'Yes', false => 'No' })
            ],
          )
        ],
      ),
      Wizardry::Pages::QuestionPage.new(
        :address,
        title: 'Address',
        before_edit: ->(object) { Rails.logger.debug("before edit #{object.identifier}") },
        before_update: ->(object) { Rails.logger.debug("before update #{object.identifier}") },
        after_update: ->(object) { Rails.logger.debug("after update #{object.identifier}") },
        questions: [
          Wizardry::Questions::ShortAnswer.new(:address_1),
          Wizardry::Questions::ShortAnswer.new(:address_2),
          Wizardry::Questions::ShortAnswer.new(:town),
          Wizardry::Questions::ShortAnswer.new(:postcode),
        ],
        pages: [
          Wizardry::Pages::QuestionPage.new(
            :london_borough,
            title: 'Which borough of London do you live in?',
            questions: [
              Wizardry::Questions::ShortAnswer.new(:london_borough),
            ],
          )
        ],
        next_pages: [
          Wizardry::Routing::NextPage.new(:london_borough, proc { |o| o.town == "London" }, label: "Town is London?")
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
      Wizardry::Pages::CheckYourAnswersPage.new(
        questions: [Wizardry::Questions::Hidden.new(:complete, true)]
      ),
      Wizardry::Pages::CompletionPage.new,
    ]
  )
end
