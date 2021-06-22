# frozen_string_literal: true

module Decidim
  module Meetings
    module Extras
      module Overrides
        autoload :CloseMeeting,     "decidim/meetings/extras/overrides/close_meeting"
        autoload :CloseMeetingForm, "decidim/meetings/extras/overrides/close_meeting_form"
        autoload :Meeting,          "decidim/meetings/extras/overrides/meeting"
        autoload :MeetingSearch,          "decidim/meetings/extras/overrides/meeting_search"
        autoload :MeetingsController, "decidim/meetings/extras/overrides/meetings_controller"
        autoload :DirectoryMeetingsController, "decidim/meetings/extras/overrides/directory_meetings_controller"
      end
    end
  end
end

