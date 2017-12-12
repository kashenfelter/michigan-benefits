module MiBridges
  class Driver
    class SchoolEnrollmentPage < FillInAndClickNextPage
      def self.title
        "School Enrollment"
      end

      def fill_in_required_fields
        choose_enrollment_time_for(snap_application.primary_member)
        choose_highest_grade_completion_for(snap_application.primary_member)
      end

      private

      def choose_enrollment_time_for(member)
        selector = if member.in_college
                     selector_for_radio("Full time")
                   else
                     selector_for_radio("Not in school")
                   end

        js_click_selector(selector)
      end

      def choose_highest_grade_completion_for(_member)
        select("Unknown", from: "highestGradeInSchool")
      end
    end
  end
end
