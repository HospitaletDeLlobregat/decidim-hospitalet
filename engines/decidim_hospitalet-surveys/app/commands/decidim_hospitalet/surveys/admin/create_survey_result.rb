# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    module Admin
      # A command with all the business logic when an admin submits a new survey.
      class CreateSurveyResult < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the proposal.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          SurveyResult.transaction do
            create_survey_result
            return broadcast(:ok, :success) unless form.email.present?
            link_survey_result_and_user
            broadcast(:ok, :user_invited)
          end
        end

        private

        attr_reader :form, :survey_result

        def create_survey_result
          @survey_result = SurveyResult.create!(
            other_priorities: form.other_priorities,
            future_ideas: form.future_ideas,
            gender: form.gender,
            age_group: form.age_group,
            zip_code: form.zip_code,
            living_at_scope: form.living_at_scope,
            working_at_scope: form.working_at_scope,
            city: form.city,
            name: form.name,
            phone: form.phone,
            selected_categories: form.categories.map(&:id),
            created_by_admin: true,
            scope: form.scope,
            user: @user,
            feature: form.current_feature
          )
        end

        def link_survey_result_and_user
          return unless user
          survey_result.update_attributes!(user: user)
        end

        def user
          return unless form.email.present?
          @user ||= Decidim::User.where(email: form.email, organization: form.current_feature.organization).first ||
                    Decidim::User.invite!(email: form.email, name: form.name, organization: form.current_feature.organization, tos_agreement: true)
        end
      end
    end
  end
end
