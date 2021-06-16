# frozen_string_literal: true

module Decidim
  module Meetings
    module Extras
      module Overrides
        autoload :CloseMeeting,     "decidim/meetings/extras/overrides/close_meeting"
        autoload :CloseMeetingForm, "decidim/meetings/extras/overrides/close_meeting_form"
      end
    end
  end
end

