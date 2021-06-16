require "decidim/meetings/extras/overrides"

module Decidim
  module Meetings
    module Extras
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Meetings::Extras

        initializer "Deface" do
          Rails.application.configure do
            config.deface.enabled = true
          end
        end

        initializer "decidim.action_controller" do
          Rails.application.reloader.to_prepare do
            ::Decidim::Meetings::CloseMeetingForm.prepend Decidim::Meetings::Extras::Overrides::CloseMeetingForm
            ::Decidim::Meetings::CloseMeeting.prepend Decidim::Meetings::Extras::Overrides::CloseMeeting
          end
        end
      end
    end
  end
end
