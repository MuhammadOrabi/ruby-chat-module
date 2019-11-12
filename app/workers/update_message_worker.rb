class UpdateMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(message_id, message)
        Message.where(id: message_id).update(message: message)
        Message.reindex
    end
end
