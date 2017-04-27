class FixSurveysIndexs < ActiveRecord::Migration[5.0]
  def change
    remove_index :decidim_hospitalet_surveys_survey_results, name: "index_unique_user_feaeture_scope_for_surveys"

    add_index :decidim_hospitalet_surveys_survey_results,
              [:decidim_feature_id, :decidim_user_id, :decidim_scope_id],
              unique: true,
              where: "(decidim_user_id IS NOT NULL)",
              name: "index_unique_user_feaeture_scope_for_surveys"
  end
end
