ENV["ENGINE_NAME"] = File.dirname(File.dirname(__FILE__)).split("/").last
require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    I18n.available_locales = [:ca, :es]
    I18n.default_locale = :ca
    I18n.locale = :ca
  end
end
