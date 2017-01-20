module DecidimHospitalet
  module Surveys
    module Admin
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

        validates :scope, presence: true
        validates :categories, length: { minimum: 1, maximum: 4 }
        validates :age_group, inclusion: { in: SurveyResult::AGE_GROUPS }, allow_blank: true
        validates :gender, inclusion: { in: SurveyResult::GENDERS }, allow_blank: true
        validates :city, inclusion: { in: Towns::TOWNS.keys }, allow_blank: true

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
          @scope ||= context.current_feature.scopes.where(id: scope_id).first
        end
      end
    end
  end
end
