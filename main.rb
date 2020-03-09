# frozen_string_literal: true

# require 'telegram/bot'
# require 'dotenv/load'


# p ENV['TELEGRAM_TOKEN']


# API key Telegram bot BotFather
# Telegram::Bot::Client.run(Figaro.env.telegram_token) do |bot|
#   bot.listen do |message|
#     bot.api.send_message(chat_id: message.chat.id, text: EasyTranslate.translate( message.text, :to => :english ))
#   end
# end

# def smart_add_url_protocol
#   unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
#     self.url = "https://#{self.url}"
#   end
# end

