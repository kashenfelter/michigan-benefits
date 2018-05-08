require "rails_helper"

RSpec.describe JobDetailsForm do
  describe "validations" do
    context "when no info provided" do
      it "is valid" do
        form = JobDetailsForm.new

        expect(form).not_to be_valid
        expect(form.errors[:some_attribute]).to be_present
      end
    end

    context "when pay quantity provided" do

    end

    context "when pay frequency provided" do

    end

    context "when pay frequency provided" do

    end
  end
end
