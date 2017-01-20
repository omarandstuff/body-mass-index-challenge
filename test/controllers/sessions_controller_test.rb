require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should post login" do
    post login_url
    assert_response :success
  end

  test "should register with the right credentials and return a user and a session token" do
    post signup_url, params: { user: { email: "omarandstuff@gmail.com", password: "12345" }}, xhr: true
    assert_response :success

    json = JSON.parse(@response.body)

    assert_equal "omarandstuff@gmail.com", json['user']['email']
    assert_equal "application/json", @response.content_type
  end

  test "should not register without the right credentials" do
    post signup_url, params: { user: { email: "omarandstuff", password: "" }}, xhr: true
    assert_response :bad_request
  end

  test "should delete logout" do
    delete logout_url
    assert_response :success
  end

end
