class CreateNavers < ActiveRecord::Migration[6.1]
  def change
    create_table :navers do |t|
      t.string :name, null: false
      t.date :birthdate, null: false
      t.date :admission_date, null: false
      t.string :job_role, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
