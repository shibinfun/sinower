SolidCable.configure do |config|
  config.polling_interval = 0.1.seconds
  config.message_retention = 1.day
end
