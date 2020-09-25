require 'rails_helper'

RSpec.describe('Completing the wizard', type: :feature) do
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
  end

  def given_i_begin_the_wizard
    visit "rating/identification"
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

  def when_i_fill_in_the_identification_page
    fill_in 'What is your full name?', with: responses.full_name
    fill_in 'What should we call you?', with: responses.name
  end

  def when_i_fill_in_the_address_page
    fill_in 'Address line one', with: responses.address_1
    fill_in 'Town', with: responses.town
    fill_in 'Postcode', with: responses.postcode
  end

  def when_i_fill_in_the_contact_details_page
    fill_in %(What's your email address), with: responses.email
    fill_in %(What's your phone number), with: responses.phone
  end

  def when_i_fill_in_the_feedback_page
    fill_in 'Are you a new or existing customer?', with: responses.customer_type
    fill_in %(What do you think about the product?), with: responses.feedback
    # ignore date for the moment, it's non-trivial to fill in
    choose responses.rating
  end

  def and_i_submit_the_form
    click_on 'Continue'
  end

  def then_i_should_be_on_the_address_page
    expect(page.current_path).to eql('/rating/address')
  end

  def then_i_should_be_on_the_contact_details_page
    expect(page.current_path).to eql('/rating/contact_details')
  end

  def then_i_should_be_on_the_feedback_page
    expect(page.current_path).to eql('/rating/feedback')
  end

  def then_i_should_be_on_the_check_your_answers_page
    expect(page.current_path).to eql('/rating/check_your_answers')
  end

  def and_my_details_should_have_been_persisted
    last_rating = Rating.last

    responses.each_pair do |field, value|
      expect(last_rating.send(field)).to eql(value)
    end
  end
end
