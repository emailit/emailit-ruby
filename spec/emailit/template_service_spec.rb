# frozen_string_literal: true

RSpec.describe Emailit::Services::TemplateService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns a Template resource" do
      stub_api(:post, "/v2/templates", status: 201, body: {
        "object" => "template", "id" => "tpl_abc", "name" => "Welcome",
      })

      template = client.templates.create(name: "Welcome", html: "<h1>Hi</h1>")

      expect(template).to be_a(Emailit::Template)
      expect(template.id).to eq("tpl_abc")
    end
  end

  describe "#get" do
    it "returns a Template resource" do
      stub_api(:get, "/v2/templates/tpl_abc", body: {
        "object" => "template", "id" => "tpl_abc", "name" => "Welcome",
      })

      template = client.templates.get("tpl_abc")

      expect(template).to be_a(Emailit::Template)
    end
  end

  describe "#update" do
    it "returns an updated Template resource" do
      stub_api(:post, "/v2/templates/tpl_abc", body: {
        "object" => "template", "id" => "tpl_abc", "name" => "Updated",
      })

      template = client.templates.update("tpl_abc", name: "Updated")

      expect(template).to be_a(Emailit::Template)
      expect(template.name).to eq("Updated")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/templates", body: {
        "data" => [{ "object" => "template", "id" => "tpl_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.templates.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(1)
    end
  end

  describe "#delete" do
    it "returns an EmailitObject" do
      stub_api(:delete, "/v2/templates/tpl_abc", body: { "deleted" => true })

      result = client.templates.delete("tpl_abc")

      expect(result).to be_a(Emailit::EmailitObject)
    end
  end

  describe "#publish" do
    it "returns a Template resource" do
      stub_api(:post, "/v2/templates/tpl_abc/publish", body: {
        "object" => "template", "id" => "tpl_abc", "published" => true,
      })

      template = client.templates.publish("tpl_abc")

      expect(template).to be_a(Emailit::Template)
      expect(template.published).to be true
    end
  end
end
