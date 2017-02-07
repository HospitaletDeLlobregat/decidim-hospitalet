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
        return unless user && user.role?(:moderator)
        can :manage, SurveyResult
        can :manage, :admin_dashboard
        can :read, Decidim::ParticipatoryProcess
        can :read, Decidim::Feature do |feature|
          feature.manifest_name.to_s == "hospitalet_surveys"
        end
      end
    end
  end
end
