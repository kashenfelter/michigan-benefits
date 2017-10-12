# frozen_string_literal: true

module Medicaid
  class ContactHomeAddress < Step
    step_attributes(
      :residential_street_address,
      :residential_city,
      :residential_zip,
    )
  end
end