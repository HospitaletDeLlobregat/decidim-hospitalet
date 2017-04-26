# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # Defines the abilities for a User. Intended to be used with `cancancan`.
    class Ability
      include CanCan::Ability

      # Initializes the ability class for the given user. Automatically merges
      # injected abilities fmor the configuration. In order to inject more
      # abilities, add this code in the `engine.rb` file of your own engine, for
      # example, inside an initializer:
      #
      #   Decidim.configure do |config|
      #     config.abilities << Decidim::MyEngine::Abilities::MyAbility
      #   end
      #
      # Note that, in development, this will force you to restart the server
      # every time you change things in your ability classes.
      #
      # user - the User that needs its abilities checked.
      # context - a Hash with some context related to the current request.
      def initialize(user, context = {})
        @user = user
        @context = context

        return unless user && (user.role?(:collaborator) || admin_or_process_admin?)
        can [:create, :preview], SurveyResult

        return unless admin_or_process_admin?
        can :manage, SurveyResult
      end

      def participatory_processes
        @participatory_processes ||= Decidim::Admin::ManageableParticipatoryProcessesForUser.for(@user)
      end

      def admin_or_process_admin?
        @user.role?(:admin) || participatory_processes.include?(@context[:current_participatory_process])
      end
    end
  end
end
