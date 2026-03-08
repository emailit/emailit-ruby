# frozen_string_literal: true

RSpec.describe Emailit::Services::SubscriberService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns a Subscriber resource" do
      stub_api(:post, "/v2/audiences/aud_1/subscribers", status: 201, body: {
        "object" => "subscriber", "id" => "sub_abc", "email" => "user@example.com",
      })

      subscriber = client.subscribers.create("aud_1", email: "user@example.com")

      expect(subscriber).to be_a(Emailit::Subscriber)
      expect(subscriber.id).to eq("sub_abc")
      expect(subscriber.email).to eq("user@example.com")
    end
  end

  describe "#get" do
    it "returns a Subscriber resource" do
      stub_api(:get, "/v2/audiences/aud_1/subscribers/sub_abc", body: {
        "object" => "subscriber", "id" => "sub_abc", "email" => "user@example.com",
      })

      subscriber = client.subscribers.get("aud_1", "sub_abc")

      expect(subscriber).to be_a(Emailit::Subscriber)
    end
  end

  describe "#update" do
    it "returns an updated Subscriber resource" do
      stub_api(:post, "/v2/audiences/aud_1/subscribers/sub_abc", body: {
        "object" => "subscriber", "id" => "sub_abc", "first_name" => "John",
      })

      subscriber = client.subscribers.update("aud_1", "sub_abc", first_name: "John")

      expect(subscriber).to be_a(Emailit::Subscriber)
      expect(subscriber.first_name).to eq("John")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/audiences/aud_1/subscribers", body: {
        "data" => [
          { "object" => "subscriber", "id" => "sub_1" },
          { "object" => "subscriber", "id" => "sub_2" },
        ],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.subscribers.list("aud_1")

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(2)
    end
  end

  describe "#delete" do
    it "returns a Subscriber resource" do
      stub_api(:delete, "/v2/audiences/aud_1/subscribers/sub_abc", body: {
        "object" => "subscriber", "id" => "sub_abc", "deleted" => true,
      })

      subscriber = client.subscribers.delete("aud_1", "sub_abc")

      expect(subscriber).to be_a(Emailit::Subscriber)
    end
  end
end
