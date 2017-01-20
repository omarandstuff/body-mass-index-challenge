require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should retrive a session along with a user at login with the right credentials" do
    post login_url, params: { email: "davidandstuff@gmail.com", password: "12345" }, xhr: true
    assert_response :success

    json = JSON.parse(@response.body)

    assert_equal "davidandstuff@gmail.com", json['user']['email']
    assert json['token']
    assert_equal "application/json", @response.content_type
  end

  test "should retrive a session along with a user at login with the right token" do
    post login_url, headers: { "HTTP_CSRF_TOKEN" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJjcmVhdGVkX2F0IjoxNDg0ODkzNTgxfQ.NeggLf_R44CEPGGrIi2ZlalAjyWG-AnR0IQi35n0a0s"} , xhr: true
    assert_response :success

    json = JSON.parse(@response.body)

    assert_equal "davidandstuff@gmail.com", json['user']['email']
    assert_equal "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJjcmVhdGVkX2F0IjoxNDg0ODkzNTgxfQ.NeggLf_R44CEPGGrIi2ZlalAjyWG-AnR0IQi35n0a0s", json['token']
    assert_equal "application/json", @response.content_type
  end

  test "should register with the right credentials and return a user and a session token" do
    post signup_url, params: { user: { email: "omarandstuff@gmail.com", password: "12345" }}, xhr: true
    assert_response :success

    json = JSON.parse(@response.body)

    assert_equal "omarandstuff@gmail.com", json['user']['email']
    assert json['token']
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
