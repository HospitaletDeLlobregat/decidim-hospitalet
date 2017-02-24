class AddAnonymousUserAndModifyExistingProposals < ActiveRecord::Migration[5.0]
  def change
    password = SecureRandom.base64(16)
    organization = Decidim::Organization.first
    user = Decidim::User.where(
        email: "enquestes@lhon-participa.cat",
        organization: organization
      ).first || Decidim::User.create!(
      {
        name: "Enquesta / Encuesta",
        password: password,
        password_confirmation: password,
        email: "enquestes@lhon-participa.cat",
        tos_agreement: "1",
        organization: organization,
        confirmed_at: Time.current
      }
    )

    Decidim::Proposals::Proposal.where(decidim_author_id: nil).update_all(decidim_author_id: user.id)
  end
end
