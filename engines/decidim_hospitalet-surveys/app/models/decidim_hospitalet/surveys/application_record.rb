# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # Abstract class from which all models in this engine inherit.
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
