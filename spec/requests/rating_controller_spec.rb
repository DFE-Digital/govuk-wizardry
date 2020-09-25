require 'rails_helper'

RSpec.describe(RatingsController, type: :request) do
  describe 'GET edit' do
    before { get '/rating/identification' }

    specify 'renders the edit template' do
      expect(response).to render_template(:edit)
    end

    context %(when the respondant navigates to a step they've not yet reached) do
      specify 'they should be redirected back to their correct place'
    end
  end
end
