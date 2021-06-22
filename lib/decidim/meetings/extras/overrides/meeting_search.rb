module Decidim
  module Meetings
    module Extras
      module Overrides
        module MeetingSearch

          def search_meeting_report
            case options.fetch(:meeting_report, "all")
            when "closed"
              query.closed.where(%((closing_report->'#{I18n.locale}')::text != '' OR (closing_report->'machine_translations'->>'#{I18n.locale}')::text != ''))
            when "pending"
              query.past.where(%(closing_report IS NULL OR (closing_report->'#{I18n.locale}')::text = '' OR (closing_report->'machine_translations'->>'#{I18n.locale}')::text = ''))
            else
              query
            end
          end
        end
      end
    end
  end
end
