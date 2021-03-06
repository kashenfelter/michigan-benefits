module Integrated
  class WhoIsSelfEmployedController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_self_employed?
    end
  end
end
