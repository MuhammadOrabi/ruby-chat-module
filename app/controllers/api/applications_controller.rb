class Api::ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :update, :destroy]

    # GET /applications
    def index
        @applications = Application.select('token', 'name', 'chat_count').order('created_at DESC').all

        render json: {status: :ok, error: '', data: @applications}, status: :ok
    end

    # GET /applications/1
    def show
        render json: {status: :ok, error: '', data: {
            name: @application.name, token: @application.token, chat_count: @application.chat_count
        }}, status: :ok
    end

    # POST /applications
    def create
        @application = Application.new(application_params)
        @application.token = Digest::SHA1.hexdigest([Time.now, rand].join)
        @application.chat_count = 0
        if @application.save
            render json: {status: :created, error: '', data: {token: @application.token}}, status: :created
        else
            render json: {status: :unprocessable_entity, error: @application.errors, data: []}, status: :unprocessable_entity
        end
    end

  # PATCH/PUT /applications/1
  def update
    if @application.update(application_params)
        render json: {status: :ok, error: '', data: {
            name: @application.name, token: @application.token, chat_count: @application.chat_count
        }}, status: :ok
    else
        render json: {status: :unprocessable_entity, error: @application.errors, data: []}, status: :unprocessable_entity
    end
end

  # DELETE /applications/1
  def destroy
    render json: {status: :not_found, error: 'Not Found', data: []}, status: :not_found
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
        @application = Application.where(token: params[:id]).first
    end

    # Only allow a trusted parameter "white list" through.
    def application_params
      params.permit(:name)
    end
end
