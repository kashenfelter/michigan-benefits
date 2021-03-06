require "rails_helper"

RSpec.describe Medicaid::IntroName do
  describe "Validations" do
    it "validates presence of first name" do
      step = Medicaid::IntroName.new(
        first_name: nil,
        last_name: "Boo",
        sex: "male",
      )

      expect(step).to be_invalid
    end

    it "validates presence of first name" do
      step = Medicaid::IntroName.new(
        first_name: "Boo",
        last_name: nil,
        sex: "male",
      )

      expect(step).to be_invalid
    end

    it "validates presence of sex" do
      step = Medicaid::IntroName.new(
        first_name: "Lala",
        last_name: "Boo",
        sex: nil,
      )

      expect(step).to be_invalid
    end
  end
end
