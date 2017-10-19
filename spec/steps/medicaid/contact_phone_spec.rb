require "rails_helper"

RSpec.describe Medicaid::ContactPhone do
  describe "Validations" do
    it "validates presence" do
      step = Medicaid::ContactPhone.new(phone_number: nil)

      expect(step).to be_invalid
      expect(step.errors[:phone_number]).to eq(
        ["Make sure to provide a phone number at which we can reach you"],
      )
    end

    it "validates length" do
      step = Medicaid::ContactPhone.new(phone_number: "123123")

      expect(step).to be_invalid
      expect(step.errors[:phone_number]).to eq(
        ["Make sure your phone number is 10 digits long"],
      )
    end
  end
end