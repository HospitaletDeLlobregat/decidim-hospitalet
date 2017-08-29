# frozen_string_literal: true

module DecidimHospitalet
  module Surveys
    # Exposes the proposal resource so users can view and create them.
    class SurveyResultsController < DecidimHospitalet::Surveys::ApplicationController
      include Decidim::FormFactory
      before_action :authenticate_user!, only: [:new, :create]

      helper_method :available_scopes, :answered_surveys, :proposals_feature

      def available_scopes
        @available_scopes ||= current_organization.scopes.where.not(id: answered_surveys.pluck(:decidim_scope_id)).map do |scope|
          OpenStruct.new(id: scope.id, name: scope.name[I18n.locale.to_s])
        end
      end

      private

      def answered_surveys
        @answered_surveys ||= SurveyResult.where(user: current_user, feature: current_feature)
      end

      def proposals_feature
        Decidim::Feature.where(participatory_process: current_participatory_process, manifest_name: :proposals).first
      end
    end
  end
end
