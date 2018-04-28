module Integrated
  class JobDetailsController < MemberPerPageController
    def self.skip?(application)
      !application.anyone_employed?
    end

    def edit
      @form = form_class.new(employments: current_member.employments)
    end

    def update_models
      employments_to_update = @form.employments.map do |employment|
        attrs = form_params.dig(:form, :employments, employment.to_param)

        if attrs.present?
          employment.assign_attributes(attrs.permit(form_attrs))
        end
      end
      ActiveRecord::Base.transaction do
        employments_to_update.compact.each(&:save!)
      end
    end

    private

    def form_params
      params.fetch(:form, {}).permit(:id, employments: {})
    end

    def member_scope
      current_application.members.employed
    end
  end
end
