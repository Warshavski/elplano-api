# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_attributes = {
  username: 'admin',
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  admin: true
}

admin = User.find_by(username: admin_attributes[:username])

if admin.nil?
  User.new(admin_attributes).tap { |u| u.skip_confirmation! }.save!
end
