RSpec.shared_context('setup simple wizard') do
  let(:object) { SomeObject.new(field_one: 'abc', field_two: 'def', field_three: 'ghi') }
  let(:framework) do
    Wizardry::Framework.new(
      name: 'spec_wizard',
      class_name: 'SomeObject',
      edit_path_helper: :ratings_page_path,
      update_path_helper: :ratings_path,
      pages: [
        Wizardry::Pages::Page.new(
          :page_one, title: 'Page One', questions: [Wizardry::Questions::ShortAnswer.new(:field_one)]
        ),
        Wizardry::Pages::Page.new(
          :page_two, title: 'Page One', questions: [Wizardry::Questions::ShortAnswer.new(:field_two)]
        ),
        Wizardry::Pages::Page.new(
          :page_three, title: 'Page One', questions: [Wizardry::Questions::ShortAnswer.new(:field_three)]
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
end
