class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.references :survey, foreign_key: true
      t.text :result

      t.timestamps
    end
  end
end
