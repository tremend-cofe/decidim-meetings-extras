# frozen_string_literal: true

require "spec_helper"

describe "Explore meeting directory", type: :system do

  let(:directory) do
    Decidim::Meetings::DirectoryEngine.routes.url_helpers.root_path
  end

  let(:organization) { create(:organization) }
  let(:components) do
    create_list(:meeting_component, 3, organization: organization)
  end
  let!(:meetings) do
    components.flat_map do |component|
      create_list(:meeting, 2, :past, :published, component: component)
    end
  end

  before do
    switch_to_host(organization.host)
    visit directory
  end

  context "when filtering for closed meetings that have a report" do
    let!(:closed_meeting) do
      create(:meeting, :published, :closed, component: components.last, start_time: 1.week.ago)
    end

    it "allows filtering by closed events" do
      within ".filters" do
        choose "Past"
        choose "Events with a report"
      end

      expect(page).to have_content(closed_meeting.title["en"])
      expect(page).to have_css("#meetings-count", text: "1 MEETING")
    end

    it "allows filtering by pending report" do
      within ".filters" do
        choose "Past"
        choose "Events pending report"
      end

      expect(page).to have_css(".card--meeting", count: 6)
      expect(page).not_to have_content(closed_meeting.title["en"])
    end
  end
end
