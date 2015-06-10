class CreateDocxTemplates < ActiveRecord::Migration
  def change
    create_table :docx_templates do |t|
      t.integer :user_id
      t.string :name
      t.string :raw_template
      t.string :template_fields
      t.string :sample_template

      t.timestamps null: false
    end
  end
end
