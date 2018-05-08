module Integrated
  class JobDetailsController < MemberPerPageController
    def self.skip?(application)
      !application.anyone_employed?
    end

    def edit
      @form = form_class.new(employments: current_member.employments)
    end

    def update
      @form = form_class.new(employments: current_member.employments)
      @form.employments.map do |employment|
        attrs = form_params.dig(:employments, employment.to_param)
        if attrs.present?
          employment.assign_attributes(attrs.permit(form_attrs))
        end
      end

      if @form.valid?
        update_models
        redirect_to(next_path)
      else
        render :edit
      end
    end

    def update_models
      ActiveRecord::Base.transaction do
        @form.employments.compact.each(&:save!)
      end
    end

    private

    def form_params
      params.fetch(:form, {}).permit(*form_attrs, { employments: {} })
    end

    def member_scope
      current_application.members.employed
    end
  end
end
