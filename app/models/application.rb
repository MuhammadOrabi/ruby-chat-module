class Application < ApplicationRecord
    validates :token, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true

    has_many :chats
end
