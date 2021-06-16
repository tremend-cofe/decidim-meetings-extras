module Decidim
  module Meetings
    module Extras
      module Overrides
        module CloseMeeting

          def close_meeting
            super
            meeting.update!(
              attendees_count: form.attendees_count,
            )
          end
        end
      end
    end
  end
end
