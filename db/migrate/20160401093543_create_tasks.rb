class CreateTasks < ActiveRecord::Migration
    def change
        create_table :tasks do |t|
            t.string :file
            t.integer :user_id
            t.timestamps null: false
        end
        add_index :tasks, :user_id
    end
end
