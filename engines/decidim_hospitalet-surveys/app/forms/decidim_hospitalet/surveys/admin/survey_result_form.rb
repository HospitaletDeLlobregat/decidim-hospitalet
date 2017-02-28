# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    module Admin
      # Handles the form to create admin-submitted surveys.
      class SurveyResultForm < Decidim::Form
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
        attribute :city, String
        attribute :name, String
        attribute :phone, String
        attribute :email, String

        validates :name, presence: true, if: proc { |form| form.email.present? }
        validates :scope, :scope_id, presence: true
        validates :categories, :categories_ids, length: { minimum: 1, maximum: 4 }
        validates :age_group, inclusion: { in: SurveyResult::AGE_GROUPS }, allow_blank: true
        validates :gender, inclusion: { in: SurveyResult::GENDERS }, allow_blank: true
        validates :city, inclusion: { in: Towns::TOWNS.keys }, allow_blank: true

        4.times do |index|
          attribute :"proposal_title_#{index}", String
          attribute :"proposal_description_#{index}", String

          validates :"proposal_title_#{index}", presence: true, if: proc { |m| m.send("proposal_description_#{index}").present? }
          validates :"proposal_description_#{index}", presence: true, if: proc { |m| m.send("proposal_title_#{index}").present? }
        end

        def map_model(model)
          self.scope_id = model.decidim_scope_id
          self.categories_ids = model.selected_categories.map(&:to_s)
        end

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
          @scope ||= scopes.where(id: scope_id).first
        end

        def scopes
          @scopes ||= context.current_feature.scopes
        end

        def organization
          @organization ||= context.current_feature.organization
        end

        def invited_by
          @invited_by ||= context.current_user
        end

        def roles
          []
        end

        def invitation_instructions
          "invite_user"
        end

        def proposals_feature
          context.proposals_feature
        end
      end
    end
  end
end
