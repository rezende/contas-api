# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

user1 = User.create(email: 'user@test.com', password: '123123', password_confirmation: '123123')
user2 = User.create(email: 'user2@test.com', password: '123123', password_confirmation: '123123')

account1 = CheckingAccount.create(user: user1, name: 'First Account')
account2 = CheckingAccount.create(user: user2, name: 'Second Account')

Transaction.create(destination_account_id: account1.id, amount: 200.00, message: 'Account creation')
Transaction.create(destination_account_id: account2.id, amount: 200.00, message: 'Account creation')
