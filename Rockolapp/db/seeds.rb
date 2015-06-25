# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(name: 'a', email: 'a', password: 'a')
<<<<<<< HEAD
Superuser.create(name: 'a@a.com', email: 'a', password: 'a')
=======
Superuser.create(name: 'a', email: 'a@a.com', password: 'a')
>>>>>>> f55b42696b948b73232e3a5d04b758187d5e3f67
Genre.create(name: 'Rock', list:'whitelist')