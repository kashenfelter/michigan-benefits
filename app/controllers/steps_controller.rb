class StepsController < ApplicationController
  include ApplicationHelper

  def allowed
    {
      show: :member,
      update: :member
    }
  end

  def show # TODO: should be "edit"
    @step = Step.find(params[:id], current_app)
    respond_with @step
  end

  def update
    @step = Step.find(params[:id], current_app)
    @step.update(step_params)

    if @step.valid?
      redirect_to path_to_step(@step.next)
    else
      render :show
    end
  end

  private

  def step_params
    params.require(:step).permit @step.questions.keys
  end
end
