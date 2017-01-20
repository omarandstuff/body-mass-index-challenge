require 'test_helper'

class MassIndexRecordsControllerTest < ActionDispatch::IntegrationTest

  test "should retrive all records once the recuest has been authenticated for an user with the right token" do
    get records_index_url, headers: { "HTTP_CSRF_TOKEN" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJjcmVhdGVkX2F0IjoxNDg0ODkzNTgxfQ.NeggLf_R44CEPGGrIi2ZlalAjyWG-AnR0IQi35n0a0s"} , xhr: true
    assert_response :success

    json = JSON.parse(@response.body)

    assert_equal 2, json.count
  end

  test "should not retrive records if there's not session" do
    get records_index_url, headers: { "HTTP_CSRF_TOKEN" => "token.token.token"} , xhr: true
    assert_response :bad_request
  end

  test "should create a new record once the recuest has been authenticated for an user with the right token" do
    assert_difference('MassIndexRecord.count') do
      post records_create_url, params: { record: { body_mass_index: 666 }}, headers: { "HTTP_CSRF_TOKEN" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJjcmVhdGVkX2F0IjoxNDg0ODkzNTgxfQ.NeggLf_R44CEPGGrIi2ZlalAjyWG-AnR0IQi35n0a0s" } , xhr: true
    end
    assert_response :success

    json = JSON.parse(@response.body)

    assert_equal '666.0' , json['body_mass_index']
  end

  test "should not create if there's not session" do
    post records_create_url, params: { record: { body_mass_index: 666 }}, headers: { "HTTP_CSRF_TOKEN" => "token.token.token" } , xhr: true
    assert_response :bad_request
  end

  test "should delete a record once the recuest has been authenticated for an user with the right token" do
    assert_difference('MassIndexRecord.count', -1) do
      delete records_destroy_url(666), headers: { "HTTP_CSRF_TOKEN" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJjcmVhdGVkX2F0IjoxNDg0ODkzNTgxfQ.NeggLf_R44CEPGGrIi2ZlalAjyWG-AnR0IQi35n0a0s" } , xhr: true
    end
    assert_response :success
  end

  test "should not destroy if there's not session" do
    delete records_destroy_url(666), headers: { "HTTP_CSRF_TOKEN" => "token.token.token" } , xhr: true
    assert_response :bad_request
  end

end
