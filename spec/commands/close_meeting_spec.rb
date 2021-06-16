# frozen_string_literal: true

require "spec_helper"

module Decidim::Meetings
  describe CloseMeeting do
    subject { described_class.new(form, meeting) }

    let(:meeting) { create :meeting }
    let(:user) { create :user, :admin }
    let(:form) do
      double(
        invalid?: invalid,
        locale: "en",
        attendees_count: 10,
        closing_report: { en: "Great meeting" },
        closed_at: Time.current,
        proposal_ids: proposal_ids,
        current_user: user,
        current_organization: meeting.organization
      )
    end
    let(:proposal_component) do
      create(:component, manifest_name: :proposals, participatory_space: meeting.component.participatory_space)
    end
    let(:invalid) { false }
    let(:proposals) do
      create_list(
        :proposal,
        3,
        component: proposal_component
      )
    end
    let(:proposal_ids) { proposals.map(&:id) }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end

      it "doesn't perform any other action" do
        expect(meeting).not_to receive(:update!)
        expect(Decidim::ResourceLink).not_to receive(:create!)

        subject.call
      end
    end

  end
end
