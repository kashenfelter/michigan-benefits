class EmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application|
      ApplicationMailer.snap_application_notification(
        file_name: snap_application.pdf.path,
        recipient_email: snap_application.email,
      ).deliver

      "Emailed to #{snap_application.email}"
    end
  end
end
