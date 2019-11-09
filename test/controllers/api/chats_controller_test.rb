require 'test_helper'

class Api::ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat = chats(:one)
  end

  test "should get index" do
    get api_chats_url, as: :json
    assert_response :success
  end

  test "should create chat" do
    assert_difference('Chat.count') do
      post api_chats_url, params: { chat: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show chat" do
    get api_chat_url(@chat), as: :json
    assert_response :success
  end

  test "should update chat" do
    patch api_chat_url(@chat), params: { chat: {  } }, as: :json
    assert_response 200
  end

  test "should destroy chat" do
    assert_difference('Chat.count', -1) do
      delete api_chat_url(@chat), as: :json
    end

    assert_response 204
  end
end
