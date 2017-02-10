require 'rails_helper'

describe SessionsController do
  describe 'POST #login' do
    context 'an active token is present' do
      it 'returns the user and the token of an existing active session' do
        user = FactoryGirl.create(:david)
        token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
        session = Session.create! user: user, token: token

        request.headers[:HTTP_CSRF_TOKEN] = token
        post :login

        json_response = JSON.parse(response.body)
        expect(response).to be_success
        expect(json_response['user']).to_not be_nil
        expect(json_response['token']).to eq token
      end
    end

    context 'an erratic token is present' do
      it 'returns bad request' do
        request.headers[:HTTP_CSRF_TOKEN] = "cool_token"
        post :login

        expect(response).to_not be_success
      end
    end

    context 'the right credentials are present' do
      it 'returns the user and the token' do
        user = FactoryGirl.create(:david)

        post :login, params: { email: user.email, password: 'supersecret' }

        json_response = JSON.parse(response.body)
        expect(response).to be_success
        expect(json_response['user']).to_not be_nil
        expect(json_response['token']).to eq user.sessions.last.token
      end
    end

    context 'the wrong credentials are present' do
      it 'returns bad request' do
        post :login, params: { email: "wrong_email", password: 'wrong_password' }

        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #register' do
    context 'new right credentials are present' do
      it 'returns the created user and the token of a new session' do
        post :register, params: { user: { email: "david.deanda@tango.com", password: 'supersecret' } }

        json_response = JSON.parse(response.body)
        expect(response).to be_success
        expect(json_response['user']).to_not be_nil
        expect(json_response['token']).to eq Session.last.token
      end
    end

    context 'new erratic credentials(email) are present' do
      it 'returns bad request' do
        post :register, params: { user: { email: "david.com", password: 'supersecret' } }

        json_response = JSON.parse(response.body)
        expect(response).to_not be_success
        expect(json_response['error']).to_not be_nil
      end
    end
  end

  describe 'DELETE #logout' do
    context 'an active token is present' do
      it 'returns success and deactivate the session' do
        user = FactoryGirl.create(:david)
        token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
        session = Session.create! user: user, token: token

        request.headers[:HTTP_CSRF_TOKEN] = token
        delete :logout

        expect(response).to be_success

        session.reload

        expect(session).to_not be_active
      end
    end

    context 'an erratic token is present' do
      it 'returns bad request' do
        request.headers[:HTTP_CSRF_TOKEN] = 'cool_token'
        delete :logout

        expect(response).to_not be_success
      end
    end
  end
end
