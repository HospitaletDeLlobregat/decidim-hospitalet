# frozen_string_literal: true
module DecidimHospitlet
  module Surveys
    # The data store for a SurveyResult in the DecidimHospitalet::Surveys component.
    class SurveyResult < Surveys::ApplicationRecord
      belongs_to :feature, foreign_key: "decidim_feature_id", class_name: Decidim::Feature
      belongs_to :user, foreign_key: "decidim_user_id", class_name: Decidim::User
      belongs_to :scope, foreign_key: "decidim_scope_id", class_name: Decidim::Scope
      has_one :organization, through: :feature

      validate :user_belongs_to_organization
      validate :scope_belongs_to_organization

      private

      def user_belongs_to_organization
        return unless user
        errors.add(:user, :invalid) unless Decidim::User.where(decidim_organization_id: feature.organization.id, id: user.id).exists?
      end

      def scope_belongs_to_organization
        return unless scope
        errors.add(:scope, :invalid) unless feature.scopes.where(id: scope.id).exists?
      end
    end
  end
end
