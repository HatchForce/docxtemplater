class CreateDocxTemplates < ActiveRecord::Migration
  def change
    create_table :docx_templates do |t|

      t.timestamps null: false
    end
  end
end
