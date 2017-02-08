require 'rails_helper'

describe Sessions::Retrieve do
  describe 'process' do
    before(:each) do
      @user1 = FactoryGirl.create(:david)
      @user2 = FactoryGirl.create(:omar)

      @active_user1_token = Sessions::GenerateToken.new(@user1.id, 2.seconds.ago).process
      @active_user2_token = Sessions::GenerateToken.new(@user2.id, 2.seconds.ago).process

      @active_user1_session = Session.create! user: @user1, token: @active_user1_token
      @active_user2_session = Session.create! user: @user2, token: @active_user2_token

      @inactive_user1_token = Sessions::GenerateToken.new(@user1.id, 2.hours.ago).process
      @inactive_user2_token = Sessions::GenerateToken.new(@user2.id, 2.hours.ago).process

      @inactive_user1_session = Session.create! user: @user1, token: @inactive_user1_token, active: false
      @inactive_user2_session = Session.create! user: @user2, token: @inactive_user2_token, active: false
    end

    context 'when the token is present' do
      it 'returns a session object' do
        service = Sessions::Retrieve.new(token: @active_user1_token)

        expect(service.process).to eq @active_user1_session
      end

      context 'and session is active' do
        it 'returns an active session object' do
          service = Sessions::Retrieve.new(token: @active_user1_token)

          expect(service.process).to eq @active_user1_session

          @active_user1_session.reload

          expect(@active_user1_session).to be_active
        end
      end

      context 'and session is inactive' do
        it 'returns nil' do
          service = Sessions::Retrieve.new(token: @inactive_user1_token)

          expect(service.process).to eq nil
        end

        it 'reactivates the session if the right credentials are given' do
          service = Sessions::Retrieve.new(email: @user1.email, password: @user1.password, token: @inactive_user1_token)

          expect(service.process).to eq @inactive_user1_session

          @inactive_user1_session.reload

          expect(@inactive_user1_session).to be_active
        end

        it 'does not reactivate the session if the user is not the owner' do
          service = Sessions::Retrieve.new(email: @user2.email, password: @user2.password, token: @inactive_user1_token)

          expect(service.process).to eq nil

          @inactive_user1_session.reload

          expect(@inactive_user1_session).to_not be_active
        end
      end
    end

    context 'when the token is erratic' do
      it 'returns nil' do
        service = Sessions::Retrieve.new(token: 'erratic token')

        expect(service.process).to eq nil
      end

      context 'and the right credentials are given' do
        it 'returns a new active session' do
          service = Sessions::Retrieve.new(email: @user1.email, password: @user1.password, token: 'erratic token')
          expect{ service.process }.to change(Session, :count).by(1)
          expect(Session.last).to be_active
        end
      end

      context 'and the wrong credentials are given' do
        it 'returns nil' do
          service = Sessions::Retrieve.new(email: 'wron_gemail', password: 'wrong_password', token: 'erratic token')

          expect(service.process).to eq nil
        end
      end
    end

    context 'when there is no token' do
      context 'and the right credentials are given' do
        it 'returns a new active session' do
          service = Sessions::Retrieve.new(email: @user1.email, password: @user1.password)
          expect{ service.process }.to change(Session, :count).by(1)
          expect(Session.last).to be_active
        end
      end

      context 'and the wrong credentials are given' do
        it 'returns nil' do
          service = Sessions::Retrieve.new(email: 'wron_gemail', password: 'wrong_password')

          expect(service.process).to eq nil
        end
      end
    end
  end
end
