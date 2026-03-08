# frozen_string_literal: true

RSpec.describe Emailit::EmailitObject do
  it "supports property access via method_missing" do
    obj = described_class.new({ "id" => "test", "name" => "hello" })

    expect(obj.id).to eq("test")
    expect(obj.name).to eq("hello")
  end

  it "supports bracket access" do
    obj = described_class.new({ "id" => "test" })

    expect(obj["id"]).to eq("test")
    expect(obj["missing"]).to be_nil
  end

  it "supports bracket assignment" do
    obj = described_class.new({})
    obj["foo"] = "bar"

    expect(obj["foo"]).to eq("bar")
    expect(obj.foo).to eq("bar")
  end

  it "supports setter via method_missing" do
    obj = described_class.new({})
    obj.foo = "bar"

    expect(obj.foo).to eq("bar")
  end

  it "supports key?" do
    obj = described_class.new({ "id" => "test" })

    expect(obj.key?("id")).to be true
    expect(obj.key?("missing")).to be false
  end

  it "supports to_hash" do
    data = { "id" => "test", "name" => "hello" }
    obj = described_class.new(data)

    expect(obj.to_hash).to eq(data)
    expect(obj.to_h).to eq(data)
  end

  it "supports to_json" do
    obj = described_class.new({ "id" => "test" })

    expect(obj.to_json).to eq('{"id":"test"}')
  end

  it "supports to_s as pretty JSON" do
    obj = described_class.new({ "id" => "test" })

    expect(obj.to_s).to include('"id"')
    expect(obj.to_s).to include('"test"')
  end

  it "supports refresh_from" do
    obj = described_class.new({ "old" => true })
    obj.refresh_from({ "new" => true })

    expect(obj["new"]).to be true
    expect(obj["old"]).to be_nil
  end

  it "stores and retrieves last_response" do
    obj = described_class.new({})
    response = Emailit::ApiResponse.new(200, {}, '{}')
    obj.last_response = response

    expect(obj.last_response).to eq(response)
  end
end

RSpec.describe Emailit::ApiResource do
  it "defines class_url" do
    expect(Emailit::Email.class_url).to eq("/v2/emails")
    expect(Emailit::Domain.class_url).to eq("/v2/domains")
    expect(Emailit::Contact.class_url).to eq("/v2/contacts")
  end

  it "defines resource_url" do
    expect(Emailit::Email.resource_url("em_123")).to eq("/v2/emails/em_123")
  end

  it "defines instance_url" do
    email = Emailit::Email.new({ "id" => "em_123" })
    expect(email.instance_url).to eq("/v2/emails/em_123")
  end

  it "raises on instance_url without id" do
    email = Emailit::Email.new({})
    expect { email.instance_url }.to raise_error(RuntimeError, /has no 'id'/)
  end
end

RSpec.describe Emailit::Collection do
  it "returns data" do
    collection = described_class.new({
      "data" => [{ "id" => "1" }, { "id" => "2" }],
      "next_page_url" => nil,
    })

    expect(collection.data.length).to eq(2)
  end

  it "is countable" do
    collection = described_class.new({ "data" => [{ "id" => "1" }] })

    expect(collection.count).to eq(1)
    expect(collection.size).to eq(1)
    expect(collection.length).to eq(1)
  end

  it "is enumerable" do
    collection = described_class.new({
      "data" => [
        Emailit::EmailitObject.new({ "id" => "a" }),
        Emailit::EmailitObject.new({ "id" => "b" }),
      ],
    })

    ids = collection.map(&:id)
    expect(ids).to eq(["a", "b"])
  end

  it "reports has_more?" do
    with_more = described_class.new({ "data" => [], "next_page_url" => "/v2/emails?page=2" })
    without_more = described_class.new({ "data" => [], "next_page_url" => nil })

    expect(with_more.has_more?).to be true
    expect(without_more.has_more?).to be false
  end
end

RSpec.describe Emailit::Util do
  it "converts data with object type to typed resource" do
    obj = described_class.convert_to_emailit_object({ "object" => "email", "id" => "em_1" })

    expect(obj).to be_a(Emailit::Email)
    expect(obj.id).to eq("em_1")
  end

  it "converts list data to Collection with typed items" do
    obj = described_class.convert_to_emailit_object({
      "data" => [
        { "object" => "email", "id" => "em_1" },
        { "object" => "email", "id" => "em_2" },
      ],
      "next_page_url" => nil,
    })

    expect(obj).to be_a(Emailit::Collection)
    expect(obj.data[0]).to be_a(Emailit::Email)
  end

  it "returns EmailitObject for unknown type" do
    obj = described_class.convert_to_emailit_object({ "unknown" => true })

    expect(obj).to be_a(Emailit::EmailitObject)
  end

  it "returns nil for nil input" do
    expect(described_class.convert_to_emailit_object(nil)).to be_nil
  end
end
