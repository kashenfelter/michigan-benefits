class JobDetailsForm < Form
  set_member_attributes(
    :id,
    :employments,
    :employer_name,
    :hourly_or_salary,
    :payment_frequency,
    :pay_quantity,
    :hours_per_week
  )
end
