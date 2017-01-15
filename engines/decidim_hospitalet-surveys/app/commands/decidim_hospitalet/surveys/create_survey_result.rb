# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # A command with all the business logic when a user submits a new survey.
    class CreateSurveyResult < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(form, feature)
        @feature = feature
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

        create_survey_result
        broadcast(:ok, survey_result)
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
          scope: form.scope,
          user: form.user,
          feature: @feature
        )
      end
    end
  end
end
