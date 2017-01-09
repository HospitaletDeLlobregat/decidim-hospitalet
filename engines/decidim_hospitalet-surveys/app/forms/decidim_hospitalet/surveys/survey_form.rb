# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # A form object to be used when public users want to anser a survey.
    class SurveyForm < Decidim::Form
      mimic :survey_result

      attribute :user, Decidim::User
      attribute :scope_id, Integer
      attribute :category_id, Integer
      attribute :feature, Decidim::Feature

      attribute :other_priorities, String
      attribute :future_ideas, String
      attribute :gender, String
      attribute :age_group, String
      attribute :zip_code, String
      attribute :living_at_scope, Boolean
      attribute :working_at_scope, Boolean
      attribute :city, String
      attribute :name, String
      attribute :phone, String

      validates :user, :category, :scope, :feature, presence: true

      # Finds the Categories from the category_id.
      #
      # Returns a Decidim::Category
      def categories
        @category ||= feature.categories.where(id: category_id)
      end

      # Finds the Scope from the scope_id.
      #
      # Returns a Decidim::Scope
      def scope
        @scope ||= feature.scopes.where(id: scope_id).first
      end
    end
  end
end
