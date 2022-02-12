class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :transactions, id: :uuid, default: -> { 'public.gen_random_uuid()' } do |t|
      t.string :customer
      t.decimal :input_amount, precision: 10, scale: 2
      t.string :input_currency
      t.decimal :output_amount, precision: 10, scale: 2
      t.string :output_currency

      t.timestamps
    end
  end
end
