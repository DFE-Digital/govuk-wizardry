require 'rails_helper'

RSpec.describe('Errors: trying to complete an already-completed wizard', type: :feature) do
  include_context "common wizard steps"

  scenario "I should trigger an aready completed error when interacting with a completed wizard" do
    given_i_begin_the_wizard

    # page 1: identification
    when_i_fill_in_the_identification_page
    and_i_submit_the_form

    # mark the wizard as complete
    when_the_wizard_marked_as_complete

    # page 2: address
    then_i_should_be_on_the_address_page
    when_i_fill_in_the_address_page

    # submitting the form should trigger an already completed error
    then_submitting_the_form_causes_an_error
  end

  def when_the_wizard_marked_as_complete
    last_rating.update(complete: true)
  end

  def then_submitting_the_form_causes_an_error
    expect { click_on('Continue') }.to raise_error(Wizardry::AlreadyCompletedError)
  end

  def responses
    @responses ||= OpenStruct.new(
      full_name: 'Milhaus van Houten',
      name: 'Milhaus',

      address_1: '87 Something Avenue',
      town: 'Springfield',
      postcode: 'SP1 2EQ',
    )
  end
end
