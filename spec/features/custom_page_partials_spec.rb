require 'rails_helper'

RSpec.describe('Completing the wizard: custom page partials', type: :feature) do
  include_context "common wizard steps"

  scenario "Form contents can be overridden with partials" do
    given_a_partial_exists_for_the_name_check_form
    and_i_begin_the_wizard

    # page 1: identification
    when_i_fill_in_the_identification_page
    and_i_submit_the_form

    # Note the wizard is set to go to the :are_you_sure step when the full name
    # of 'Joe Bloggs' is submitted
    #
    # page 2: name check
    then_i_should_be_on_the_are_you_sure_page
    and_i_see_the_customised_page_partial_content

    # Fill in incorrectly to ensure errors rendered properly
    when_i_dont_enter_anything
    and_i_submit_the_form
    then_i_should_see_an_error_message

    # Now fill in correctly and ensure we proceed
    when_i_confirm_that_im_sure
    and_i_submit_the_form
    then_i_should_be_on_the_address_page
  end

private

  def responses
    @responses ||= OpenStruct.new(full_name: 'Joe Bloggs', name: 'Joe')
  end

  def given_a_partial_exists_for_the_name_check_form
    expect(File).to exist(Rails.root.join("app/views/ratings/_name_check_form.html.erb"))
  end

  def then_i_should_be_on_the_are_you_sure_page
    expect(page.current_path).to eql('/rating/are-you-sure')
  end

  def when_i_dont_enter_anything; end

  def when_i_confirm_that_im_sure
    fill_in 'Are you sure?', with: 'true'
  end

  def and_i_see_the_customised_page_partial_content
    expect(page).to have_css('h1', text: 'Really sure?')
    expect(page).to have_css('p', text: 'Text from the partial')
    expect(page).to have_css('button', text: "Continue")
  end

  def then_i_should_see_an_error_message
    expect(page).to have_css('.govuk-error-summary', text: 'There is a problem')
    expect(page).to have_css('.govuk-form-group--error', text: /Enter an answer/)
  end
end
