class AddStateToTodos < ActiveRecord::Migration[8.0]
  def change
   change_table :todos do |t|
    t.boolean :active, default: true, null: false
   end
  end
end
