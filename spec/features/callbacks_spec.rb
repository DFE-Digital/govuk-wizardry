require 'rails_helper'

RSpec.describe('Triggering callbacks', type: :feature) do
  include_context "common wizard steps"

  before { allow(Rails.logger).to receive(:debug) { true } }

  scenario "after update is not triggered when validation fails" do
    given_i_begin_the_wizard

    # page 1: identification
    when_i_fill_in_the_identification_page
    and_i_submit_the_form

    # page 2: address (incorrect submission)
    then_i_should_be_on_the_address_page
    and_the_before_edit_callback_should_have_been_triggered

    when_i_incorrectly_fill_in_the_address_page
    and_i_submit_the_form

    then_i_should_be_on_the_address_page
    and_the_before_update_callback_should_have_been_triggered
    but_the_after_update_callback_should_not_have_been_triggered
  end

  scenario "after update is triggered when validation succeeds" do
    given_i_begin_the_wizard

    # page 1: identification
    when_i_fill_in_the_identification_page
    and_i_submit_the_form

    # page 2: address (correct submisison)
    then_i_should_be_on_the_address_page
    and_the_before_edit_callback_should_have_been_triggered

    when_i_fill_in_the_address_page
    and_i_submit_the_form

    then_the_before_update_callback_should_have_been_triggered
    and_the_after_update_callback_should_have_been_triggered

    # page 3: contact details
    then_i_should_be_on_the_contact_details_page
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

  def and_the_before_edit_callback_should_have_been_triggered
    log_received(message: "before edit")
  end

  def and_the_before_update_callback_should_have_been_triggered
    log_received(message: "before update")
  end
  alias_method(
    :then_the_before_update_callback_should_have_been_triggered,
    :and_the_before_update_callback_should_have_been_triggered
  )

  def but_the_after_update_callback_should_not_have_been_triggered
    log_not_received(message: "after update")
  end

  def and_the_after_update_callback_should_have_been_triggered
    log_received(message: "after update")
  end

  def when_i_incorrectly_fill_in_the_address_page
    # do nothing
  end

private

  def log_received(message:, rating: Rating.last)
    expect(Rails.logger).to expectation(message, rating)
  end

  def log_not_received(message:, rating: Rating.last)
    expect(Rails.logger).not_to expectation(message, rating)
  end

  def expectation(message, rating)
    have_received(:debug).with(/#{message} #{rating.identifier}/)
  end
end
