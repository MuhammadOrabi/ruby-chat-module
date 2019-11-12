class Api::MessagesController < ApplicationController
    before_action :set_app
    before_action :set_chat
    before_action :set_message, only: [:show, :update, :destroy]

    # GET /messages
    def index
        search = params[:query].present? ? params[:query] : nil
        @messages = if search
            begin
                Message.search(search, where: {chat_id: @chat.id}, order: {number: :desc})
            rescue StandardError => e
                puts e.message
                puts e.backtrace.inspect
                @chat.messages.where("message LIKE ?", '%' + search + '%').select('number', 'message').order('number DESC')
            end
        else
            @chat.messages.select('number', 'message').order('number DESC')
        end
        @messages = @messages.map do |m|
            { number: m.number, message: m.message }
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
        if message_params[:message] && !message_params[:message].empty?
            number = @chat.message_count + 1
            @chat.update(message_count: @chat.message_count + 1)

            CreateMessageWorker.perform_async(message_params[:message], @chat.id, number)

            render json: {status: :created, error: '', data: {number: number}}, status: :created
        else
            render json: {status: :unprocessable_entity, error: 'invalid message', data: []}, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /messages/1
    def update
        if message_params[:message] && !message_params[:message].empty?
            UpdateMessageWorker.perform_async(@message.id, params[:message])
            render json: {status: :ok, error: '', data: {number: @message.number}}, status: :ok
        else
            render json: {status: :unprocessable_entity, error: 'invalid message', data: []}, status: :unprocessable_entity
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
