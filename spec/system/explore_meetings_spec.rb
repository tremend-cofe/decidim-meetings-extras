# frozen_string_literal: true

require "spec_helper"

describe "Explore meetings", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "meetings" }

  let(:meetings_count) { 5 }
  let!(:meetings) do
    create_list(:meeting, meetings_count, :past, :not_official, :published, component: component)
  end

  before do
    component_scope = create :scope, parent: participatory_process.scope
    component_settings = component["settings"]["global"].merge!(scopes_enabled: true, scope_id: component_scope.id)
    component.update!(settings: component_settings)
  end

  describe "index" do
    context "when filtering" do
      let!(:closed_meeting) {
        create(:meeting, :published, :closed, component: component, start_time: 1.week.ago)
      }

      it "displays all the meetings " do
        page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )

        within ".filters" do
          check "Past"
        end

        within ".meeting_report_collection_radio_buttons_filter" do
          choose "All"
        end

        expect(page).to have_css(".card--meeting", count: 6)
      end

      it "allows filtering by closing report" do
        page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )

        within ".filters" do
          check "Past"
          choose "Events with a report"
        end

        expect(page).to have_css(".card--meeting", count: 1)
        expect(page).to have_content(translated(closed_meeting.title))
      end

      it "allows filtering by pending report" do
        page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )

        within ".filters" do
          check "Past"
          choose "Events pending report"
        end

        expect(page).to have_css(".card--meeting", count: 5)
        expect(page).not_to have_content(translated(closed_meeting.title))
      end
    end
  end
end
