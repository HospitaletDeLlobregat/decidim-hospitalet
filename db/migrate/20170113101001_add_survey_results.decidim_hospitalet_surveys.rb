# This migration comes from decidim_hospitalet_surveys (originally 20170109130000)
class AddSurveyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_hospitalet_surveys_survey_results do |t|
      t.references :decidim_feature, null: false, index: { name: "index_decidim_hospitalet_surveys_on_feature_id" }
      t.references :decidim_user, index: { name: "index_decidim_hospitalet_surveys_on_user_id" }
      t.references :decidim_scope, index: { name: "index_decidim_hospitalet_surveys_on_scope_id" }, null: false
      t.integer :selected_categories, array: true, default: [], index: { name: "index_decidim_hospitalet_surveys_on_categories_ids" }
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

    add_index :decidim_hospitalet_surveys_survey_results,
      [:decidim_feature_id, :decidim_user_id, :decidim_scope_id],
      unique: true,
      name: "index_unique_user_feaeture_scope_for_surveys"
  end
end
