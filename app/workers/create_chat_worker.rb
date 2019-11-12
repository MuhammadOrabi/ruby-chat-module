class CreateChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(app_token, number)
        app = Application.find(app_token)
        chat = Chat.new(application_id: app.id, number: number, message_count: 0)
        chat.save
    end
end
