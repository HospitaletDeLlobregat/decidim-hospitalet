# This migration comes from decidim_hospitalet_surveys (originally 20170207101556)
class AddAuthorToSurveyResults < ActiveRecord::Migration[5.0]
  def change
    change_table :decidim_hospitalet_surveys_survey_results do |t|
      t.references :decidim_author, index: { name: "index_decidim_hospitalet_surveys_on_author_id" }
    end
  end
end
