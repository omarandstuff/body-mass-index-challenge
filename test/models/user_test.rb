require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "Should not save user without a prensent and well formated email" do
    user = User.new password: '12345678'
    assert_not user.save
    assert user.errors.messages[:email]

    user = User.new email: 'email', password: '12345678'
    assert_not user.save
    assert user.errors.messages[:email]
  end

  test "Should not save user without a password" do
    user = User.new email: 'omarandstuff@gmail.com'
    assert_not user.save
    assert user.errors.messages[:password]
  end

  test "Should not permit same email for two users" do
    user = User.new email: 'omarandstuff@gmail.com', password: '12345678'
    assert user.save

    user = User.new email: 'omarandstuff@gmail.com', password: '12345678'
    assert_not user.save
    assert user.errors.messages[:email]
  end

  test "showld save user with the right credentials" do
    user = User.new email: 'omarandstuff@gmail.com', password: '12345678'
    assert user.save
  end

end
