class CreateMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(message, chat_id, number)
        chat = Chat.find(chat_id)
        message = Message.new(message: message, chat_id: chat_id, number: number)
        message.save
        Message.reindex()
    end
end
