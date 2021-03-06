require "rails_helper"

RSpec.describe IntroduceYourselfForm do
  describe "validations" do
    it "requires first_name" do
      form = IntroduceYourselfForm.new

      expect(form).not_to be_valid
      expect(form.errors[:first_name]).to be_present
    end

    it "requires last_name" do
      form = IntroduceYourselfForm.new

      expect(form).not_to be_valid
      expect(form.errors[:last_name]).to be_present
    end

    it "requires sex" do
      form = IntroduceYourselfForm.new

      expect(form).not_to be_valid
      expect(form.errors[:sex]).to be_present
    end

    it "requires sex to be either male or female" do
      form = IntroduceYourselfForm.new(sex: "plant")

      expect(form).not_to be_valid
      expect(form.errors[:sex]).to be_present
    end

    it "requires birthday subfields" do
      form = IntroduceYourselfForm.new

      expect(form).not_to be_valid
      expect(form.errors[:birthday]).to be_present
    end

    it "does not accept invalid dates for birthday" do
      form = IntroduceYourselfForm.new(birthday_year: 1992, birthday_month: 2, birthday_day: 30)

      expect(form).not_to be_valid
      expect(form.errors[:birthday]).to be_present
    end
  end
end
