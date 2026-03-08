# frozen_string_literal: true

RSpec.describe Emailit::Services::EventService do
  let(:client) { mock_client }

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/events", body: {
        "data" => [
          { "object" => "event", "id" => "evt_1", "type" => "email.delivered" },
          { "object" => "event", "id" => "evt_2", "type" => "email.bounced" },
        ],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.events.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(2)
      expect(list.data[0]).to be_a(Emailit::Event)
    end

    it "passes query parameters" do
      stub_api(:get, "/v2/events?type=email.delivered&page=1", body: {
        "data" => [{ "object" => "event", "id" => "evt_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.events.list(type: "email.delivered", page: 1)

      expect(list.count).to eq(1)
    end
  end

  describe "#get" do
    it "returns an Event resource" do
      stub_api(:get, "/v2/events/evt_abc", body: {
        "object" => "event", "id" => "evt_abc", "type" => "email.delivered",
      })

      event = client.events.get("evt_abc")

      expect(event).to be_a(Emailit::Event)
      expect(event.id).to eq("evt_abc")
      expect(event.type).to eq("email.delivered")
    end
  end
end
