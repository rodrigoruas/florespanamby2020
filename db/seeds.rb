# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# arranjo1 = Product.create(name: "Ramalhete de Rosas", "short_description")

# DeliveryCost.destroy_all

# cost1 = DeliveryCost.new([
#   { name: 'Manhã Dia de Semana', price_cents: 2000, distance: 20 },
#   { name: 'Tarde Dia de Semana', price_cents: 2000, distance: 20 },
#   { name: 'Noite Dia de Semana', price_cents: 2500, distance: 20 },
#   { name: 'Horário Comercial', price_cents: 1500, distance: 20 }
# ])

cost1 = DeliveryCost.new(name: 'Manhã Dia de Semana', price_cents: 2000, distance: 20)
cost1.save


cost2 = DeliveryCost.new(name: 'Tarde Dia de Semana', price_cents: 2500, distance: 20)
cost2.save

cost3 = DeliveryCost.new(name: 'Noite Dia de Semana', price_cents: 3000, distance: 20)
cost3.save
