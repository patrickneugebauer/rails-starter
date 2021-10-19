class CreateSamples < ActiveRecord::Migration[6.1]
  def change
    create_table :samples do |t|
      t.string :name, limit: 10, null: false
      t.timestamps
    end
  end
end
