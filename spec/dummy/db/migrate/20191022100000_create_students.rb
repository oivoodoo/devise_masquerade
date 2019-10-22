class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table(:students) do |t|
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      t.timestamps
    end

    add_index :students, :email,                unique: true
    add_index :students, :reset_password_token, unique: true
  end
end

