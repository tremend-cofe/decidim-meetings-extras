module Decidim
  module Meetings
    module Extras
      module Overrides
        module Meeting
          def self.prepended(base)
            base.class_eval do
              scope :closed, -> { where.not(closed_at: nil) }
            end
          end
        end
      end
    end
  end
end
