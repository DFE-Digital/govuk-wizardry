require 'rails_helper'

RSpec.describe('Completing the wizard: with optional pages', type: :feature) do
  include_context "common wizard steps"

  scenario "I encounter pages conditionally based on my answers" do
    given_i_begin_the_wizard

    # page 1: identification
    when_i_fill_in_the_identification_page
    and_i_submit_the_form

    # page 2: address
    then_i_should_be_on_the_address_page
    when_i_fill_in_the_address_page
    and_i_submit_the_form

    # page 3: london borough, only available when `town: 'London'`
    then_i_should_be_on_the_london_borough_page
    when_i_fill_in_my_london_borough
    and_i_submit_the_form

    # page 4: contact details (formerly page 3)
    then_i_should_be_on_the_contact_details_page
    and_my_details_should_have_been_persisted
  end

  def responses
    @responses ||= OpenStruct.new(
      full_name: 'Milhaus van Houten',
      name: 'Milhaus',

      address_1: '87 Something Avenue',
      town: 'London',
      postcode: 'SP1 2EQ',

      london_borough: 'Hounslow',
    )
  end

  def then_i_should_be_on_the_london_borough_page
    expect(page.current_path).to eql('/rating/london-borough')
  end

  def when_i_fill_in_my_london_borough
    fill_in 'Which local authority district do you live in?', with: responses.london_borough
  end
end
