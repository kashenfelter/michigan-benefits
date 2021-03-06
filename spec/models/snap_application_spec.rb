require "rails_helper"

RSpec.describe SnapApplication do
  describe "common benefit application" do
    let(:subject) do
      create(:medicaid_application)
    end

    it_should_behave_like "common benefit application"
  end

  describe "enums" do
    context "applied_before" do
      it "should be 'unfilled' by default" do
        app = build(:snap_application)
        expect(app.applied_before_unfilled?).to be(true)
      end
    end
  end

  describe "validations" do
    [
      [:care_expenses, SnapApplication::CARE_EXPENSES],
      [:medical_expenses, SnapApplication::MEDICAL_EXPENSES],
      [:court_ordered_expenses, SnapApplication::COURT_ORDERED_EXPENSES],
    ].each do |field, approved_values|
      context field.to_s do
        it "is valid with all allowed values" do
          app = build(
            :snap_application,
            field => approved_values,
          )

          expect(app).to be_valid
        end

        it "is valid with only one allowed value" do
          app = build(
            :snap_application,
            field => [approved_values.first],
          )

          expect(app).to be_valid
        end

        it "is invalid with an arbitrary value" do
          app = build(
            :snap_application,
            field => ["random_word"],
          )

          expect(app).not_to be_valid
        end
      end
    end
  end

  describe "#pdf" do
    it "delegates to the Dhs1171Pdf class" do
      app = build(:snap_application)

      fake_pdf_builder = double(completed_file: "I am fake. It's OK")
      allow(Dhs1171Pdf).to receive(:new).with(snap_application: app).
        and_return(fake_pdf_builder)

      expect(app.pdf).to eql(fake_pdf_builder.completed_file)
    end
  end

  describe "#gross_income" do
    context "no members" do
      it "adds all sources of income" do
        app = build(
          :snap_application,
          income_child_support: nil,
          income_other: nil,
          income_pension: nil,
          income_social_security: nil,
          income_ssi_or_disability: nil,
          income_unemployment_insurance: nil,
          income_workers_compensation: 10,
        )

        expect(app.monthly_gross_income).to eq 10
      end
    end

    context "members present" do
      it "adds members' monthly income" do
        member = build(:member)
        app = create(:snap_application, members: [member])
        allow(member).to receive(:monthly_income).and_return(100)

        expect(app.monthly_gross_income).to eq 100
      end
    end
  end

  describe "#residential_address" do
    context "mailing_address_same_as_residential_address is true" do
      it "returns mailing address" do
        app = create(:snap_application,
                      mailing_address_same_as_residential_address: true)
        create(:residential_address, benefit_application: app)
        mailing_address = create(:mailing_address, benefit_application: app)

        expect(app.residential_address).to eq mailing_address
      end
    end

    context "mailing_address_same_as_residential_address is false" do
      context "residential address not present" do
        it "returns NullAddress" do
          app = create(:snap_application)
          create(:mailing_address, benefit_application: app)

          expect(app.residential_address).to be_a NullAddress
        end
      end

      context "residential address present" do
        context "housing is stable" do
          it "returns residential address" do
            app = create(:snap_application)
            create(:mailing_address, benefit_application: app)
            residential_address =
              create(:residential_address, benefit_application: app)

            expect(app.residential_address).to eq residential_address
          end
        end

        context "housing is not stable" do
          it "returns NullAddress" do
            app = create(:snap_application, stable_housing: false)
            create(:mailing_address, benefit_application: app)
            _residential_address =
              create(:residential_address, benefit_application: app)

            expect(app.residential_address.class).to eq NullAddress
          end
        end
      end
    end
  end

  describe "#faxed?" do
    context "when no fax attempts have been made" do
      it "returns false" do
        snap_application = create(:snap_application)
        expect(snap_application).to_not be_faxed
      end
    end

    context "when a failed fax attempt has been made" do
      it "returns false" do
        snap_application = create(:snap_application,
          exports: [create(:export, :faxed, :failed)])
        expect(snap_application).to_not be_faxed
      end
    end

    context "when a successful fax attempt has been made" do
      it "returns true" do
        snap_application = create(:snap_application,
          exports: [create(:export, :faxed, :succeeded)])
        expect(snap_application).to be_faxed
      end
    end

    context "when several fax attempts have led to mixed results" do
      it "returns true" do
        snap_application = create(:snap_application,
          exports: [create(:export, :faxed, :failed),
                    create(:export, :faxed, :succeeded),
                    create(:export, :faxed, :failed)])
        expect(snap_application).to be_faxed
      end
    end
  end

  describe "#drive_status" do
    context "when there are no drive attempts or errors" do
      it "returns :drive_none" do
        snap_application = create(:snap_application)

        expect(snap_application.drive_status).to eq :drive_none
      end
    end

    context "when there are drive attempts and no errors" do
      it "returns :drive_success" do
        driven_application = create(:driver_application)
        snap_application = driven_application.snap_application

        expect(snap_application.drive_status).to eq :drive_success
      end
    end

    context "when there are drive attempts and some errors" do
      it "returns :drive_errors" do
        driver_error = create(:driver_error)
        driven_application = driver_error.driver_application
        snap_application = driven_application.snap_application

        expect(snap_application.drive_status).to eq :drive_errors
      end
    end
  end

  describe "#latest_drive_attempt" do
    it "returns the most recent associated drive attempt" do
      app = create(:snap_application)
      _oldest = create(:driver_application, snap_application: app)
      latest = create(:driver_application, snap_application: app)

      expect(app.latest_drive_attempt).to eq latest
    end
  end

  describe "#office_location" do
    context "when selected office location clio or union" do
      it "returns selected office location" do
        app1 = create(:snap_application,
          selected_office_location: "clio",
          office_page: "foo")
        app2 = create(:snap_application,
          selected_office_location: "union",
          office_page: "foo")

        expect(app1.office_location).to eq("clio")
        expect(app2.office_location).to eq("union")
      end
    end

    context "when selected office location is not clio or union" do
      it "returns nil" do
        app = create(:snap_application, selected_office_location: "other")

        expect(app.office_location).to eq(nil)
      end
    end

    context "when selected office location not present" do
      it "returns office page" do
        app = create(:snap_application,
          selected_office_location: nil,
          office_page: "union")

        expect(app.office_location).to eq("union")
      end
    end
  end
end
