# frozen_string_literal: true

RSpec.describe Emailit::Services::ContactService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns a Contact resource" do
      stub_api(:post, "/v2/contacts", status: 201, body: {
        "object" => "contact", "id" => "con_abc", "email" => "user@example.com",
      })

      contact = client.contacts.create(email: "user@example.com")

      expect(contact).to be_a(Emailit::Contact)
      expect(contact.id).to eq("con_abc")
      expect(contact.email).to eq("user@example.com")
    end
  end

  describe "#get" do
    it "returns a Contact resource" do
      stub_api(:get, "/v2/contacts/con_abc", body: {
        "object" => "contact", "id" => "con_abc", "email" => "user@example.com",
      })

      contact = client.contacts.get("con_abc")

      expect(contact).to be_a(Emailit::Contact)
    end
  end

  describe "#update" do
    it "returns an updated Contact resource" do
      stub_api(:post, "/v2/contacts/con_abc", body: {
        "object" => "contact", "id" => "con_abc", "first_name" => "John",
      })

      contact = client.contacts.update("con_abc", first_name: "John")

      expect(contact).to be_a(Emailit::Contact)
      expect(contact.first_name).to eq("John")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/contacts", body: {
        "data" => [
          { "object" => "contact", "id" => "con_1" },
          { "object" => "contact", "id" => "con_2" },
        ],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.contacts.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(2)
    end
  end

  describe "#delete" do
    it "returns a Contact resource" do
      stub_api(:delete, "/v2/contacts/con_abc", body: {
        "object" => "contact", "id" => "con_abc", "deleted" => true,
      })

      contact = client.contacts.delete("con_abc")

      expect(contact).to be_a(Emailit::Contact)
    end
  end
end
