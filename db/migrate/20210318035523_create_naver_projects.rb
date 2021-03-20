class CreateNaverProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :naver_projects do |t|
      t.references :naver, null: false, foreign_key: {on_delete: :cascade}
      t.references :project, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
