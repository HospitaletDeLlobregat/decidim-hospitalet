# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # A form object to be used when public users want to anser a survey.
    class SurveyForm < Decidim::Form
      mimic :survey_result

      attribute :scope_id, Integer
      attribute :categories_ids, Integer

      attribute :other_priorities, String
      attribute :future_ideas, String
      attribute :gender, String
      attribute :age_group, String
      attribute :zip_code, String
      attribute :living_at_scope, Boolean
      attribute :working_at_scope, Boolean
      attribute :authorize_lopd, Boolean
      attribute :city, String

      validates :scope, presence: true
      validates :categories, length: { minimum: 1, maximum: 4 }
      validates :age_group, inclusion: { in: SurveyResult::AGE_GROUPS }, allow_blank: true
      validates :gender, inclusion: { in: SurveyResult::GENDERS }, allow_blank: true
      validates :city, inclusion: { in: Towns::TOWNS.keys }, allow_blank: true
      validates :authorize_lopd, allow_nil: false, acceptance: true

      # Finds the Categories from the category_id.
      #
      # Returns a Decidim::Category
      def categories
        @categories ||= context.current_feature.categories.where(id: categories_ids)
      end

      # Finds the Scope from the scope_id.
      #
      # Returns a Decidim::Scope
      def scope
        @scope ||= context.current_feature.scopes.where(id: scope_id).first
      end
    end
  end
end
