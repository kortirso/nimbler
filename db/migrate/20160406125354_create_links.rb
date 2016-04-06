class CreateLinks < ActiveRecord::Migration
    def change
        create_table :links do |t|
            t.string :type
            t.string :name
            t.integer :word_id
            t.timestamps null: false
        end
        add_index :links, :word_id
    end
end
