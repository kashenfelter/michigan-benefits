class Employment < ApplicationRecord
  belongs_to :application_member, polymorphic: true, counter_cache: true

  PAYCHECK_INTERVALS = {
    week: "Weekly",
    two_weeks: "Every Two Weeks",
    twice_a_month: "Twice a Month",
    month: "Monthly",
    year: "Yearly",
  }.freeze

  enum hourly_or_salary: { unfilled: 0, hourly: 1, salaried: 2 }
end
