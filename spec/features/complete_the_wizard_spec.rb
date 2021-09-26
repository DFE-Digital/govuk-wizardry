require 'rails_helper'

RSpec.describe('Completing the wizard: completion', type: :feature) do
  include_context "common wizard steps"

  scenario "I should be able to complete every step by entering valid answers" do
    given_i_begin_the_wizard

    # page 1: identification
    when_i_fill_in_the_identification_page
    and_i_submit_the_form

    # page 2: address
    then_i_should_be_on_the_address_page
    when_i_fill_in_the_address_page
    and_i_submit_the_form

    # page 3: contact details
    then_i_should_be_on_the_contact_details_page
    when_i_fill_in_the_contact_details_page
    and_i_submit_the_form

    # page 4: feedback
    then_i_should_be_on_the_feedback_page
    when_i_fill_in_the_feedback_page
    and_i_submit_the_form

    # page 5: check your answers
    then_i_should_be_on_the_check_your_answers_page
    and_my_details_should_have_been_persisted
    and_i_complete_the_wizard

    # page 6: completion
    then_i_should_be_on_the_completion_page
  end

  def responses
    @response ||= OpenStruct.new(
      full_name: 'Milhaus van Houten',
      name: 'Milhaus',

      address_1: '87 Something Avenue',
      town: 'Springfield',
      postcode: 'SP1 2EQ',

      phone: '0153 124 1288',
      email: 'thrillhouse@hotmail.com',

      rating: 'Alright',
      customer_type: 'New',
      feedback: 'Excellent service',
    )
  end
end
