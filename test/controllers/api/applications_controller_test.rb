require 'test_helper'

class Api::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application = applications(:one)
  end

  test "should get index" do
    get api_applications_url, as: :json
    assert_response :success
  end

  test "should create application" do
    assert_difference('Application.count') do
      post api_applications_url, params: { application: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show application" do
    get api_application_url(@application), as: :json
    assert_response :success
  end

  test "should update application" do
    patch api_application_url(@application), params: { application: {  } }, as: :json
    assert_response 200
  end

  test "should destroy application" do
    assert_difference('Application.count', -1) do
      delete api_application_url(@application), as: :json
    end

    assert_response 204
  end
end
