class CreateWords < ActiveRecord::Migration
    def change
        create_table :words do |t|
            t.integer :task_id
            t.integer :total_links
            t.integer :total_results
            t.string :html_result
            t.timestamps null: false
        end
        add_index :words, :task_id
    end
end
