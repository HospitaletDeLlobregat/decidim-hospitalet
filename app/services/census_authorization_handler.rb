# frozen_string_literal: true

# Checks the authorization against the census for Barcelona.
require "digest/md5"

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  attribute :document_number, String
  attribute :postal_code, String
  attribute :date_of_birth, Date

  validates :date_of_birth, presence: true
  validates :document_number, format: { with: /\A[A-z0-9]*\z/ }, presence: true
  validates :postal_code, presence: true, format: { with: /\A[0-9]*\z/ }

  validate :response_valid
  validate :older_than_sixteen

  # If you need to store any of the defined attributes in the authorization you
  # can do it here.
  #
  # You must return a Hash that will be serialized to the authorization when
  # it's created, and available though authorization.metadata
  def metadata
    super.merge(postal_code: postal_code)
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def sanitized_date_of_birth
    @sanitized_date_of_birth ||= date_of_birth&.strftime("%d/%m/%Y")
  end

  def response_valid
    errors.add(:document_number, I18n.t("census_authorization_handler.invalid_document")) if response.blank? || response.xpath("//EsHabitantResult").text != "true"
  end

  def response
    return nil if document_number.blank? || date_of_birth.blank?

    return @response if defined?(@response)

    connection = Faraday.new(url: "https://seuelectronica.l-h.cat", ssl: { verify: false })

    response = connection.post do |request|
      request.url "/Padro/wsPadroHabitant.asmx"
      request.headers["Content-Type"] = "application/soap+xml"
      request.body = request_body
    end

    @response = Nokogiri::XML(response.body).remove_namespaces!
  end

  def request_body
    @request_body ||= <<~SOAP
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <EsHabitant xmlns="https://seuelectronica.l-h.cat/Padro/">
            <DocId>#{sanitize document_number&.upcase}</DocId>
            <DataNaix>#{sanitized_date_of_birth}</DataNaix>
          </EsHabitant>
        </soap12:Body>
      </soap12:Envelope>
    SOAP
  end

  def older_than_sixteen
    errors.add(:date_of_birth, I18n.t("census_authorization_handler.age_under_16")) unless age && age >= 16
  end

  def age
    return nil if date_of_birth.blank?

    now = Date.current
    extra_year = (now.month > date_of_birth.month) || (
      now.month == date_of_birth.month && now.day >= date_of_birth.day
    )

    now.year - date_of_birth.year - (extra_year ? 0 : 1)
  end
end
