require 'rails_helper'

RSpec.describe(WizardryHelper, type: :helper) do
  include_context 'setup simple wizard'

  subject { helper.wizardry_content(wizard) }

  let(:object) { SomeObject.new(field_one: 'abc', field_two: 'def', field_three: 'ghi') }

  describe "#wizardry_content" do
    describe 'rendering a questions page' do
      let(:wizard) { Wizardry::Instance.new(object: object, framework: framework, current_page: :page_two) }

      specify 'renders a form wrapped in a turbo-frame-tag' do
        expect(subject).to have_css('turbo-frame-tag > form')
      end

      specify 'the form has the expected fields' do
        expect(subject).to have_text("Field_two")
        expect(subject).to have_css("input#some-object-field-two-field")
      end

      specify "the form has a submit button" do
        expect(subject).to have_button("Continue")
      end

      context "when the object is invalid" do
        let(:error_id) { "#some-object-field-two-field-error" }
        let(:error_message) { "add some data please" }
        before { object.errors.add(:field_two, :presence, message: error_message) }

        specify "an error summary is rendered" do
          expect(subject).to have_css(".govuk-error-summary")
        end

        specify "the error summary links to the field containing errors" do
          expect(subject).to have_css("input#{error_id}")
          expect(subject).to have_link(error_message, href: error_id)
        end
      end
    end

    describe 'rendering the check your answers page' do
      let(:wizard) { Wizardry::Instance.new(object: object, framework: framework, current_page: :check_your_answers) }

      specify 'renders a summary list' do
        expect(subject).to have_css('.govuk-summary-list')
      end
    end

    describe 'rendering the completion page' do
      let(:wizard) { Wizardry::Instance.new(object: object, framework: framework, current_page: :completion) }

      specify 'renders the completion placeholder page' do
        expect(subject).to have_css('h1', text: 'Completed')
        expect(subject).to have_content('Add a partial called _completion_page.html.erb to override this message')
      end
    end
  end
end
