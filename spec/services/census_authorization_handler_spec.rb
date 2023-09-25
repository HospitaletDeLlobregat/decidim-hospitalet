# frozen_string_literal: true

require "rails_helper"
require "decidim/dev/test/authorization_shared_examples"

describe CensusAuthorizationHandler do
  subject { handler }

  let(:handler) { described_class.from_params(params) }
  let(:document_number) { "12345678A" }
  let(:postal_code) { "08901" }
  let(:date_of_birth) { Date.civil(1963, 12, 26) }
  let(:params) do
    {
      document_number: document_number,
      postal_code: postal_code,
      date_of_birth: date_of_birth
    }
  end

  before do
    handler.user = create(:user, nickname: "test_user")
  end

  it_behaves_like "an authorization handler"

  context "with a valid response" do
    before do
      allow(handler)
        .to receive(:response)
        .and_return(Nokogiri::XML("<EsHabitantResult>true</EsHabitantResult>").remove_namespaces!)
    end

    describe "document_number" do
      context "when it isn't present" do
        let(:document_number) { nil }

        it { is_expected.not_to be_valid }
      end

      context "with an invalid format" do
        let(:document_number) { "(╯°□°）╯︵ ┻━┻" }

        it { is_expected.not_to be_valid }
      end
    end

    describe "postal_code" do
      context "when it isn't present" do
        let(:postal_code) { nil }

        it { is_expected.not_to be_valid }
      end

      context "when it has an invalid format" do
        let(:postal_code) { "(ヘ･_･)ヘ┳━┳" }

        it { is_expected.not_to be_valid }
      end
    end

    describe "date_of_birth" do
      context "when it isn't present" do
        let(:date_of_birth) { nil }

        it { is_expected.not_to be_valid }
      end

      context "when it's under 16" do
        let(:date_of_birth) { 15.years.ago }

        it { is_expected.not_to be_valid }
      end

      context "when data from a date field is provided" do
        let(:params) do
          {
            "date_of_birth(1i)" => "2010",
            "date_of_birth(2i)" => "8",
            "date_of_birth(3i)" => "16"
          }
        end

        let(:date_of_birth) { nil }

        it "correctly parses the date" do
          expect(subject.date_of_birth.year).to eq(2010)
          expect(subject.date_of_birth.month).to eq(8)
          expect(subject.date_of_birth.day).to eq(16)
        end
      end
    end

    context "when everything is fine" do
      it { is_expected.to be_valid }
    end
  end

  describe "unique_id" do
    it "generates a different ID for a different document number" do
      handler.document_number = "ABC123"
      unique_id1 = handler.unique_id

      handler.document_number = "XYZ456"
      unique_id2 = handler.unique_id

      expect(unique_id1).not_to eq(unique_id2)
    end

    it "generates the same ID for the same document number" do
      handler.document_number = "ABC123"
      unique_id1 = handler.unique_id

      handler.document_number = "ABC123"
      unique_id2 = handler.unique_id

      expect(unique_id1).to eq(unique_id2)
    end

    it "hashes the document number" do
      handler.document_number = "ABC123"
      unique_id = handler.unique_id

      expect(unique_id).not_to include(handler.document_number)
    end
  end

  context "with an invalid response" do
    context "with a malformed response" do
      before do
        allow(handler)
          .to receive(:response)
          .and_return(Nokogiri::XML("Messed up response!").remove_namespaces!)
      end

      it { is_expected.not_to be_valid }
    end

    context "with an invalid response code" do
      before do
        allow(handler)
          .to receive(:response)
          .and_return(Nokogiri::XML("<EsHabitantResult>false</EsHabitantResult>").remove_namespaces!)
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe "metadata" do
    it "includes the postal code" do
      expect(subject.metadata).to include(postal_code: "08901")
    end
  end
end
