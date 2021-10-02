RSpec.shared_context('setup branched wizard') do
  let(:framework) do
    Wizardry::Framework.new(
      name: 'spec_wizard',
      class_name: 'SomeObjectWithOptionalSteps',
      edit_path_helper: :ratings_page_path,
      update_path_helper: :ratings_path,
      pages: [
        Wizardry::Pages::QuestionPage.new(
          :page_one, title: 'Page One', questions: [Wizardry::Questions::ShortAnswer.new(:field_one)]
        ),

        Wizardry::Pages::QuestionPage.new(
          :page_two, title: 'Page Two', questions: [Wizardry::Questions::ShortAnswer.new(:field_two)],
          next_pages: [
            Wizardry::Routing::NextPage.new(:page_three, proc { |o| o.field_two == "Shazam" })
          ],
          pages: [
            Wizardry::Pages::QuestionPage.new(
              :page_three,
              title: 'Page Three',
              questions: [Wizardry::Questions::ShortAnswer.new(:field_three)],

              # skip page four when we complete page three
              next_pages: [Wizardry::Routing::NextPage.new(:page_five)],
            ),
          ]
        ),

        Wizardry::Pages::QuestionPage.new(
          :page_four, title: 'Page Four', questions: [Wizardry::Questions::ShortAnswer.new(:field_four)]
        ),

        Wizardry::Pages::QuestionPage.new(
          :page_five, title: 'Page Five', questions: [Wizardry::Questions::ShortAnswer.new(:field_five)]
        ),
        Wizardry::Pages::CheckYourAnswersPage.new,
        Wizardry::Pages::CompletionPage.new,
      ]
    )
  end
end

class SomeObjectWithOptionalSteps
  include ActiveModel::Model

  attr_accessor :field_one, :field_two, :field_two_a, :field_three, :field_four

  validates :field_one, presence: true, on: :page_one
  validates :field_two, presence: true, on: :page_two
  validates :field_three, presence: true, on: :page_three
  validates :field_four, presence: true, on: :page_four
  validates :field_five, presence: true, on: :page_five
end
