class AddPositionToSurveyAnswerOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_surveys_survey_answer_options, :position, :integer, default: 0
  end
end
