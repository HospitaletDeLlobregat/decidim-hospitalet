# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_NAME"] = File.dirname(__dir__).split("/").last

Decidim::Dev.dummy_app_path = File.expand_path(File.join(".."))

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    I18n.available_locales = [:ca, :es]
    I18n.default_locale = :ca
    I18n.locale = :ca
  end
end
