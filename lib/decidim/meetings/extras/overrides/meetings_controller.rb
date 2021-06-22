module Decidim
  module Meetings
    module Extras
      module Overrides
        module MeetingsController

          def default_filter_params
            super.merge({ meeting_report: %w(all closed pending) })
          end
        end
      end
    end
  end
end
