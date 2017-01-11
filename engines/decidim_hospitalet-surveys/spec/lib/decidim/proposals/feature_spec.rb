require "spec_helper"

describe "Hospitalet surveys feature" do
  let!(:feature) { create(:surveys_feature) }

  describe "on destroy" do
    context "when there are no survey submissions for the feature" do
      it "destroys the feature" do
        expect do
          Decidim::Admin::DestroyFeature.call(feature)
        end.to change { Decidim::Feature.count }.by(-1)

        expect(feature).to be_destroyed
      end
    end

    context "when there are survey submissions for the feature" do
      before do
        create(:survey_result, feature: feature)
      end

      it "raises an error" do
        expect do
          Decidim::Admin::DestroyFeature.call(feature)
        end.to broadcast(:invalid)

        expect(feature).to_not be_destroyed
      end
    end
  end
end
