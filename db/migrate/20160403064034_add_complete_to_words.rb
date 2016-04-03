class AddCompleteToWords < ActiveRecord::Migration
    def change
        add_column :words, :complete, :boolean, default: false
    end
end
