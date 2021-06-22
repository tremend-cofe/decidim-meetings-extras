module Decidim
  module Meetings
    module Extras
      module Overrides
        module CloseMeetingForm
          def self.prepended(base)
            base.class_eval do
              attribute :attendees_count, Integer, default: 0

              validates :attendees_count,
                        presence: true,
                        numericality: { greater_than_or_equal_to: 0, only_integer: true }
            end
          end
        end
      end
    end
  end
end
