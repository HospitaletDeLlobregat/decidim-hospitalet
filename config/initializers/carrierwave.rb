# frozen_string_literal: true
# Default CarrierWave setup.
#
CarrierWave.configure do |config|
  config.permissions = 0o666
  config.directory_permissions = 0o777
end

# Setup CarrierWave to use Amazon S3. Add `gem "carrierwave-aws" to your Gemfile.
#
if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :aws
    config.aws_bucket = "decidim-hospitalet"
    config.aws_acl    = "public-read"
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: "max-age=604800"
    }

    config.aws_credentials = {
      access_key_id:     Rails.application.secrets.aws_access_key_id,
      secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region:            "eu-central-1"
    }
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = !Rails.env.test?
  end
end
