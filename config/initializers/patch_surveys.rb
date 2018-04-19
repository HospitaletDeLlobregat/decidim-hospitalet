Decidim::Surveys::SurveyAnswerOption.class_eval do
  default_scope { order('position asc, id asc') }
end
