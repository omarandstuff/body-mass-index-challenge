require 'rails_helper'

describe SessionsController do
  describe 'POST #login' do
    it 'returns the user and the token' do
      user = FactoryGirl.create(:david)

      post :login, params: { email: user.email, password: 'supersecret' }

      json_response = JSON.parse(response.body)
      expect(response).to be_success
      expect(json_response['user']).to_not be_nil
      expect(json_response['token']).to eq user.sessions.last.token
    end
  end
end
