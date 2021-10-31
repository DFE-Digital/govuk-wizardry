require 'rails_helper'

RSpec.describe('Completing the wizard: validation', type: :feature) do
  include_context "common wizard steps"

  scenario "I encounter error messages when my responses aren't valid" do
    given_i_begin_the_wizard

    # page 1: identification first attempt
    when_i_attempt_to_fill_in_the_identification_page
    and_i_submit_the_form

    # page 1: with errors
    then_i_should_see_an_error_summary_with_two_errors
    and_error_messages_should_accompany_the_form_inputs

    # page 2: continuing as normal
    when_i_successfully_fill_in_the_identification_page
    and_i_submit_the_form
    then_i_should_be_on_the_address_page
  end

  def responses
    @responses ||= OpenStruct.new(full_name: 'Milhaus van Houten', name: 'Milhaus')
  end

  def when_i_attempt_to_fill_in_the_identification_page
    # not actually filling anything in
  end

  def expected_error_messages
    { 'full_name' => %r{Enter your full name}, 'name' => %r{Tell us how we should address you} }
  end

  def then_i_should_see_an_error_summary_with_two_errors
    within('.govuk-error-summary') do
      expected_error_messages.each_value do |message|
        expect(page).to have_css('ul.govuk-error-summary__list > li', text: message)
      end
    end
  end

  def and_error_messages_should_accompany_the_form_inputs
    expected_error_messages.each do |attribute, message|
      selector = %(.govuk-form-group > span#rating-#{attribute.dasherize}-error.govuk-error-message)

      expect(page).to have_css(selector, text: message)
    end
  end

  def when_i_successfully_fill_in_the_identification_page
    fill_in 'What is your full name?', with: responses.full_name
    fill_in 'What should we call you?', with: responses.name
  end
end
