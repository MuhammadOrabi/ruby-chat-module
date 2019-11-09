require 'test_helper'

class Api::MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = messages(:one)
  end

  test "should get index" do
    get api_messages_url, as: :json
    assert_response :success
  end

  test "should create message" do
    assert_difference('Message.count') do
      post api_messages_url, params: { message: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show message" do
    get api_message_url(@message), as: :json
    assert_response :success
  end

  test "should update message" do
    patch api_message_url(@message), params: { message: {  } }, as: :json
    assert_response 200
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete api_message_url(@message), as: :json
    end

    assert_response 204
  end
end
