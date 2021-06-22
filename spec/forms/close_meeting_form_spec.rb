# frozen_string_literal: true

require "spec_helper"

module Decidim::Meetings
  describe CloseMeetingForm do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:meeting) { create(:meeting, component: component) }
    let(:component) { create(:meeting_component) }
    let(:attributes) do
      {
        attendees_count: attendees_count,
        closing_report: closing_report
      }
    end
    let(:attendees_count) { 10 }
    let(:closing_report) { "It went great" }
    let(:context) do
      {
        current_organization: meeting.organization,
        current_component: component,
        current_participatory_space: component.participatory_space
      }
    end

    it { is_expected.to be_valid }


    describe "when attendees_count is missing" do
      let(:attendees_count) { nil }

      it { is_expected.not_to be_valid }
    end

    describe "when attendees_count is invalid" do
      let(:attendees_count) { "a" }

      it { is_expected.not_to be_valid }
    end
  end
end
