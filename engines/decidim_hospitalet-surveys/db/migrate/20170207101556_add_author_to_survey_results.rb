class AddAuthorToSurveyResults < ActiveRecord::Migration[5.0]
  def change
    change_table :decidim_hospitalet_surveys_survey_results do |t|
      t.references :decidim_author, index: { name: "index_decidim_hospitalet_surveys_on_author_id" }
    end
  end
end
