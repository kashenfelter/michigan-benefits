require_relative "boot"
require_relative "../lib/delayed_job_web_logger"
require "rails/all"

Bundler.require(*Rails.groups)

module MichiganBenefits
  class Application < Rails::Application
    config.action_controller.action_on_unpermitted_parameters = :raise

    # Project configuration
    config.site_name = "Michigan Benefits"
    config.project_description = ""
    config.active_job.queue_adapter = :delayed_job

    config.filter_parameters += [:ssn]
    config.middleware.insert_after Warden::Manager, DelayedJobWebLogger

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :rspec, fixture: true
      g.stylesheets     false
      g.javascripts     false
    end
  end
end
