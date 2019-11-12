class Api::ChatsController < ApplicationController
    before_action :set_app
    before_action :set_chat, only: [:show, :update, :destroy]

    # GET /chats
    def index
        @chats = @app.chats.select('number', 'message_count').order('created_at DESC').all

        render json: {status: :ok, error: '', data: @chats}, status: :ok
    end

    # GET /chats/1
    def show
        render json: {status: :ok, error: '', data: {
            number: @chat.number, message_count: @chat.message_count
        }}, status: :ok
    end

    # POST /chats
    def create
        number = @app.chat_count + 1

        @app.update(chat_count: number)

        CreateChatWorker.perform_async(@app.id, number)

        render json: {status: :created, error: '', data: {number: number}}, status: :created
    end

    # PATCH/PUT /chats/1
    def update
        render json: {status: :not_found, error: 'Not Found', data: []}, status: :not_found
    end

    # DELETE /chats/1
    def destroy
        render json: {status: :not_found, error: 'Not Found', data: []}, status: :not_found
    end

    private
        def set_app
            @app = Application.where(token: params[:application_id]).first
            if !@app
                render json: {status: :not_found, error: 'Application not found', data: []}, status: :not_found
            end
        end
        def set_chat
            @chat = @app.chats.where(number: params[:id]).first
            if !@chat
                render json: {status: :not_found, error: 'Chat not found', data: []}, status: :not_found
            end
        end
end
