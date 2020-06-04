class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.monetize :min_price, amount: { null: true, default: nil }
      t.monetize :max_price, amount: { null: true, default: nil }
    end
  end
end
