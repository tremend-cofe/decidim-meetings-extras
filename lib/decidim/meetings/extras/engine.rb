require "decidim/meetings/extras/overrides"
require 'decidim/meetings'

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
            ActiveSupport.on_load :action_controller do
              helper Decidim::LayoutHelper if respond_to?(:helper)
            end

            ::Decidim::Meetings::CloseMeetingForm.prepend Decidim::Meetings::Extras::Overrides::CloseMeetingForm
            ::Decidim::Meetings::CloseMeeting.prepend Decidim::Meetings::Extras::Overrides::CloseMeeting
            ::Decidim::Meetings::Meeting.prepend Decidim::Meetings::Extras::Overrides::Meeting
            ::Decidim::Meetings::MeetingSearch.prepend Decidim::Meetings::Extras::Overrides::MeetingSearch
            ::Decidim::Meetings::MeetingsController.prepend Decidim::Meetings::Extras::Overrides::MeetingsController
            ::Decidim::Meetings::Directory::MeetingsController.prepend Decidim::Meetings::Extras::Overrides::DirectoryMeetingsController
          end
        end
      end
    end
  end
end
