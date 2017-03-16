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
            create_proposals
            return broadcast(:ok, :user_invited) if form.email.present?
            broadcast(:ok, :success)
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
            author: form.current_user,
            scope: form.scope,
            user: existing_user || invited_user,
            feature: form.current_feature
          )
        end

        def create_proposals
          return unless form.proposals_feature

          [
            build_proposal(form.proposal_title_0, form.proposal_description_0),
            build_proposal(form.proposal_title_1, form.proposal_description_1),
            build_proposal(form.proposal_title_2, form.proposal_description_2),
            build_proposal(form.proposal_title_3, form.proposal_description_3)
          ].compact.map(&:save!)
        end

        def build_proposal(title, description)
          return unless title.present? || description.present?

          Decidim::Proposals::Proposal.new(
            title: title,
            body: description,
            author: user,
            feature: form.proposals_feature,
            scope: form.scope
          )
        end

        def user
          return default_user unless form.email.present?
          return @user if @user
          @user ||= existing_user || invited_user
        end

        def existing_user
          return unless form.email.present?
          Decidim::User.where(
            email: form.email,
            organization: form.current_feature.organization
          ).first
        end

        def default_user
          Decidim::User.where(
            email: "enquestes@lhon-participa.cat",
            organization: form.current_feature.organization
          ).first
        end

        def invited_user
          return unless form.email.present?
          Decidim::InviteUser.call(form) do
            on(:ok) do |user|
              return user
            end
          end
        end
      end
    end
  end
end
