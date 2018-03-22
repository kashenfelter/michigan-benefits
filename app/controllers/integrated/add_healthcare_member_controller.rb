module Integrated
  class AddHealthcareMemberController < AddMemberController
    def update_models
      member_data = member_params
      combine_birthday_fields(member_data)
      member_data[:requesting_healthcare] = "yes"
      current_application.members.create(member_data)
    end

    def overview_path
      healthcare_sections_path
    end
  end
end
