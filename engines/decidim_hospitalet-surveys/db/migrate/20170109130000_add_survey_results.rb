class AddSurveyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_hospitalet_surveys_survey_results do |t|
      t.references :decidim_feature, index: true, null: false
      t.references :decidim_user, index: true
      t.references :decidim_scope, index: true, null: false
      t.integer :decidim_categories_ids, default: [], index: true
      t.text :other_priorities
      t.text :future_ideas
      t.string :gender
      t.string :age_group
      t.string :zip_code
      t.boolean :living_at_scope
      t.boolean :working_at_scope
      t.string :city
      t.string :name
      t.string :phone
      t.timestamps
    end
  end
end
