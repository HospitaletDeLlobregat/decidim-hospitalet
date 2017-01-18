# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # The data store for a SurveyResult in the DecidimHospitalet::Surveys component.
    class SurveyResult < Surveys::ApplicationRecord
      GENDERS = %w{female male}.freeze
      AGE_GROUPS = [
        "0-17",
        "18-24",
        "25-34",
        "35-49",
        "50-64",
        "65+"
      ].freeze

      belongs_to :feature, foreign_key: "decidim_feature_id", class_name: Decidim::Feature
      belongs_to :user, foreign_key: "decidim_user_id", class_name: Decidim::User
      belongs_to :scope, foreign_key: "decidim_scope_id", class_name: Decidim::Scope
      has_one :organization, through: :feature

      validates :scope, :feature, presence: true
      validate :user_belongs_to_organization
      validate :scope_belongs_to_organization
      validates :scope, uniqueness: { scope: [:feature, :user] }
      validates :selected_categories, length: { minimum: 1, maximum: 4 }, if: Proc.new { |object| object.feature.present? }

      private

      def user_belongs_to_organization
        return unless user
        return unless feature
        errors.add(:user, :invalid) unless Decidim::User.where(decidim_organization_id: feature.organization.id, id: user.id).exists?
      end

      def scope_belongs_to_organization
        return unless scope
        return unless feature
        errors.add(:scope, :invalid) unless feature.scopes.where(id: scope.id).exists?
      end
    end
  end
end
