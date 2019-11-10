class Api::MessagesController < ApplicationController
    before_action :set_app
    before_action :set_chat
    before_action :set_message, only: [:show, :update, :destroy]

    # GET /messages
    def index
        search = params[:query].present? ? params[:query] : nil
        @messages = if search
            Message.search(search, where: {chat_id: @chat.id}, order: {number: :desc}).map do |m|
                { number: m.number, message: m.message }
            end
        else
            @chat.messages.select('number', 'message').order('number DESC')
        end
        render json: {status: :ok, error: '', data: @messages}, status: :ok
    end

    # GET /messages/1
    def show
        render json: {status: :ok, error: '', data: {
            number: @message.number, message: @message.message
        }}, status: :ok
    end

    # POST /messages
    def create
        @last_message = @chat.messages.order('number DESC').first
        number = 1
        if @last_message
            number = @last_message.number + 1
        end
        @message = Message.new(message_params)
        @message.chat_id = @chat.id
        @message.number = number
        if @message.save
            Message.reindex(async: true)
            @chat.update(message_count: @chat.message_count + 1)
            render json: {status: :created, error: '', data: {number: @message.number}}, status: :created
        else
            render json: {status: :unprocessable_entity, error: @message.errors, data: []}, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /messages/1
    def update
        if @message.update(message_params)
            Message.reindex(async: true)
            render json: {status: :ok, error: '', data: {number: @message.number}}, status: :ok
        else
            render json: {status: :unprocessable_entity, error: @message.errors, data: []}, status: :unprocessable_entity
        end
    end

    # DELETE /messages/1
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
        @chat = @app.chats.where(number: params[:chat_id]).first
        if !@chat
            render json: {status: :not_found, error: 'Chat not found', data: []}, status: :not_found
        end
    end
    def set_message
        @message = @chat.messages.where(number: params[:id]).first
        if !@message
            render json: {status: :not_found, error: 'message not found', data: []}, status: :not_found
        end
    end
    # Only allow a trusted parameter "white list" through.
    def message_params
        params.permit(:message)
    end
end
