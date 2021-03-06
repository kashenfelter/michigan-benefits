require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusMember do
  describe "Validations" do
    context "at least one household member is married" do
      it "is valid" do
        member = build(:member, married: true)
        member_not_married =
          build(:member, married: false)

        step = Medicaid::IntroMaritalStatusMember.new(
          members: [member, member_not_married],
        )

        expect(step).to be_valid
      end
    end

    context "no household member is married" do
      it "is invalid" do
        members = build_list(:member, 2, married: false)

        step = Medicaid::IntroMaritalStatusMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
