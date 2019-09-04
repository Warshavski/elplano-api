# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.find_or_initialize_by(
  username: 'admin',
  email: ENV['ADMIN_EMAIL'],
  admin: true
)

admin.password = ENV['ADMIN_PASSWORD']
admin.skip_confirmation!

admin.save!
