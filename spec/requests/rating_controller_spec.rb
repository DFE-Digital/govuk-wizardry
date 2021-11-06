require 'rails_helper'

RSpec.describe(RatingsController, type: :request) do
  describe 'rendering the first page of the wizard' do
    before { get '/rating/identification' }

    specify 'renders the edit template' do
      expect(response).to render_template(:edit)
    end

    specify 'sets the identification cookie' do
      expect(cookies['ratings-wizard']).to be_present
    end
  end

  describe 'completing the wizard' do
    before do
      get '/rating/identification'

      RatingFactory.create(last_completed_step: 'rating', identifier: cookies['ratings-wizard'])
    end

    specify 'clears the identification cookie' do
      expect(cookies['ratings-wizard']).to be_present

      patch '/rating/check-your-answers', params: { rating: { complete: true } }

      expect(cookies['ratings-wizard']).to be_blank
    end
  end
end
