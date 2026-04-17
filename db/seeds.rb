# This file should ensure the existence of records required to run the application
# in every environment in which it's expected to run.
#
# This is especially important for records that other records depend on,
# records that serve as defaults, or records that must always exist for
# the application to function properly.
#
# To run this file, execute:
#
#   bin/rails db:seed
#

puts "Seeding users..."
User.destroy_all
admin = User.create!(
  email: '123456@qq.com',
  password: '123456',
  password_confirmation: '123456',
  admin: true
)
puts "✓ Created admin user: #{admin.email}"


