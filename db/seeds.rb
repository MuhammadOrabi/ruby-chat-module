# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |i|
   app = Application.create({
        token: Digest::SHA1.hexdigest([Time.now, rand].join),
        chat_count: 0,
        name: "app #{i + 1}"
    })
    100.times do |j|
        chat = Chat.create({
            number: j + 1,
            application_id: app.id,
            message_count: 0
        })
        100.times do |index|
            Message.create({
                chat_id: chat.id,
                message: Faker::Lorem.sentence,
                number: index + 1
            })
        end
        chat.update({message_count: 100})
    end
    app.update({chat_count: 100})
end
Message.reindex
