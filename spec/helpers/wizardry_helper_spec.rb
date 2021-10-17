require 'rails_helper'

RSpec.describe(WizardryHelper, type: :helper) do
  include_context 'setup simple wizard'
  let(:object) { SomeObject.new(field_one: 'abc', field_two: 'def', field_three: 'ghi') }

  describe 'rendering the check your answers page' do
    let(:wizard) { Wizardry::Instance.new(object: object, framework: framework, current_page: :check_your_answers) }

    before { assign(:wizard, wizard)}

    specify 'should render a summary list' do
      expect(helper.wizardry_content).to have_css('.govuk-summary-list')
    end
  end

  describe 'rendering the completion page' do
    let(:wizard) { Wizardry::Instance.new(object: object, framework: framework, current_page: :completion) }

    before { assign(:wizard, wizard) }

    specify 'should render the completion placeholder page' do
      expect(helper.wizardry_content).to have_css('h1', text: 'Completed')
      expect(helper.wizardry_content).to have_content('Add a partial called _completion.html.erb to override this message')
    end
  end
end
