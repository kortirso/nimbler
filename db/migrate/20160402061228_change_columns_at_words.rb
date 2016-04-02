class ChangeColumnsAtWords < ActiveRecord::Migration
    def change
        change_table :words do |t|
            t.change :total_results, :string
        end
    end
end
