RSpec.shared_context('setup simple wizard') do
  let(:framework) do
    Wizardry::Framework.new(
      name: 'spec_wizard',
      class_name: 'SomeObject',
      edit_path_helper: :ratings_page_path,
      update_path_helper: :ratings_path,
      pages: [
        Wizardry::Pages::QuestionPage.new(
          :page_one, title: 'Page One', questions: [Wizardry::Questions::ShortAnswer.new(:field_one)]
        ),
        Wizardry::Pages::QuestionPage.new(
          :page_two, title: 'Page Two', questions: [Wizardry::Questions::ShortAnswer.new(:field_two)]
        ),
        Wizardry::Pages::QuestionPage.new(
          :page_three, title: 'Page Three', questions: [Wizardry::Questions::ShortAnswer.new(:field_three)]
        ),
        Wizardry::Pages::CheckYourAnswersPage.new,
        Wizardry::Pages::CompletionPage.new,
      ]
    )
  end
end

class SomeObject
  include ActiveModel::Model

  attr_accessor :field_one, :field_two, :field_three

  validates :field_one, presence: true, on: :page_one
  validates :field_two, presence: true, on: :page_two
  validates :field_three, presence: true, on: :page_three
end
