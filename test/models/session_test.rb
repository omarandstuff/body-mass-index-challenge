require 'test_helper'

class SessionTest < ActiveSupport::TestCase

  test "Should not save if without a present and well formated token" do
    user = User.create email: 'omarandstuff@gmail.com', password: '12345678'

    session = Session.new user: user
    assert_not session.save
    assert session.errors.messages[:token]

    session = Session.new token: "token", user: user
    assert_not session.save
    assert session.errors.messages[:token]
  end

  test "Should not save if it's not asociated with a user" do
    session = Session.new token: 'token.token_._token'
    assert_not session.save
    assert session.errors.messages[:user]
  end

  test "Should save with the right token and user" do
    user = User.create email: 'omarandstuff@gmail.com', password: '12345678'
    session = Session.new token: 'token.token_._token', user: user
    assert session.save
  end

  test "Should respond to user association" do
    user = User.create email: 'omarandstuff@gmail.com', password: '12345678'
    session = Session.create token: 'token.token_._token', user: user

    assert session.user
  end
end
