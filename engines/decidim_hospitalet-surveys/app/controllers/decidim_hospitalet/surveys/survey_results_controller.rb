# frozen_string_literal: true

module DecidimHospitalet
  module Surveys
    # Exposes the proposal resource so users can view and create them.
    class SurveyResultsController < DecidimHospitalet::Surveys::ApplicationController
      include Decidim::FormFactory
      before_action :authenticate_user!, only: [:new, :create]

      def new
        @form = form(SurveyForm).from_params({}, author: current_user, feature: current_feature)
      end

      def create
        @form = form(SurveyForm).from_params(params, author: current_user, feature: current_feature)

        CreateSurveyResult.call(@form) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.create.success", scope: "decidim")
            redirect_to proposal_path(proposal)
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.create.error", scope: "decidim")
            render :new
          end
        end
      end
    end
  end
end
