class JobDetailsForm < Form
  # From https://stackoverflow.com/questions/29823884/rails-currency-validation#comment47774572_29824032
  DOLLAR_REGEX = /^\$?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$/

  set_member_attributes(:employments)

  set_employment_attributes(
    :employer_name,
    :hourly_or_salary,
    :payment_frequency,
    :pay_quantity,
    :hours_per_week
  )

  validate :employments_valid


  def employments_valid
    employments.each do |employment|

      employment.errors.clear
      if employment.pay_quantity.present? && !employment.pay_quantity.match?(DOLLAR_REGEX)
        employment.errors.add("pay_quantity", "Make sure to enter a number")
      end
    end

    return true if employments.map(&:errors).all?(&:blank?)
    errors.add(:employments)
    false
  end

end
