class PersonalDetailController < SnapStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      member.update!(step_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(member_attributes)
  end

  def member_attributes
    {
      sex: member.sex,
      marital_status: member.marital_status,
      ssn: member.ssn,
    }
  end

  def member
    current_application.members.first ||
      current_application.members.new
  end
end
