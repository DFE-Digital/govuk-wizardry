RSpec.shared_context "common wizard steps" do
  def given_i_begin_the_wizard
    visit 'rating/identification'
  end

  def when_i_fill_in_the_identification_page
    fill_in 'What is your full name?', with: responses.full_name
    fill_in 'What should we call you?', with: responses.name
  end
  alias_method :when_i_successfully_fill_in_the_identification_page, :when_i_fill_in_the_identification_page

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
  alias_method :and_i_complete_the_wizard, :and_i_submit_the_form

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
    expect(page).to have_css('h1', text: 'Check your answers')
  end

  def and_my_details_should_have_been_persisted
    responses.each_pair do |field, value|
      expect(last_rating.send(field)).to eql(value)
    end
  end

  def then_i_should_be_on_the_completion_page
    expect(page).to have_css('h1', text: 'Completed')
  end

  def last_rating
    Rating.last
  end
end
