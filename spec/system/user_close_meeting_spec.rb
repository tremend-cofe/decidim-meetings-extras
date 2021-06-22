# frozen_string_literal: true

require "spec_helper"
require "decidim/proposals/test/capybara_proposals_picker"

describe "User edit meeting", type: :system do
  include_context "with a component"
  let(:manifest_name) { "meetings" }

  let!(:user) { create :user, :confirmed, organization: participatory_process.organization }
  let!(:another_user) { create :user, :confirmed, organization: participatory_process.organization }
  let!(:meeting) do
    create(:meeting,
           :published,
           :past,
           title: { en: "Meeting title with #hashtag" },
           description: { en: "Meeting description" },
           author: user,
           component: component)
  end
  let(:component) do
    create(:meeting_component,
           :with_creation_enabled,
           participatory_space: participatory_process)
  end

  before do
    switch_to_host user.organization.host
    page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )
  end

  describe "closing my own meeting" do
    let(:closing_report) { "The meeting went pretty well, yep." }

    before do
      login_as user, scope: :user
    end

    it "updates the related attributes" do
      page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )

      within ".date_check_boxes_tree_filter" do
        check "Past"
      end

      click_link translated(meeting.title)
      click_link "Close meeting"

      expect(page).to have_content "CLOSE MEETING"

      within "form.edit_close_meeting" do
        expect(page).to have_content "Choose proposals"

        fill_in :close_meeting_closing_report, with: closing_report
        fill_in :close_meeting_attendees_count, with: 10

        click_button "Close meeting"
      end

      expect(page).to have_content(closing_report)
      expect(page).not_to have_content "Close meeting"
      expect(page).to have_content "ATTENDEES COUNT"
      expect(page).not_to have_content "ATTENDING ORGANIZATIONS"
      expect(meeting.reload.closed_at).not_to be nil
    end

    context "when proposal linking is disabled" do
      before do
        allow(Decidim::Meetings).to receive(:enable_proposal_linking).and_return(false)
      end

      it "does not display the proposal picker" do
        page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )

        within ".date_check_boxes_tree_filter" do
          check "Past"
        end

        click_link translated(meeting.title)
        click_link "Close meeting"

        expect(page).to have_content "CLOSE MEETING"

        within "form.edit_close_meeting" do
          expect(page).not_to have_content "Choose proposals"
        end
      end
    end
  end

  describe "closing someone else's meeting" do
    before do
      login_as another_user, scope: :user
    end

    it "doesn't show the button" do
      page.visit Decidim::EngineRouter.main_proxy(component).root_path(locale: "en", filter: { date: { past: [""] } } )

      within ".date_check_boxes_tree_filter" do
        check "Past"
      end

      click_link translated(meeting.title)
      expect(page).to have_no_content("Close meeting")
    end
  end
end
