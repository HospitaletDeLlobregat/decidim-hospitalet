# This migration comes from decidim_hospitalet_surveys (originally 20170120093953)
class AddCreatedByAdminToSurveyResults < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_hospitalet_surveys_survey_results, :created_by_admin, :boolean, default: false
  end
end
