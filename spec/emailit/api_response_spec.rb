# frozen_string_literal: true

RSpec.describe Emailit::ApiResponse do
  it "parses JSON body" do
    response = described_class.new(200, { "content-type" => "application/json" }, '{"id":"test"}')

    expect(response.status_code).to eq(200)
    expect(response.json).to eq({ "id" => "test" })
    expect(response.body).to eq('{"id":"test"}')
    expect(response.headers).to eq({ "content-type" => "application/json" })
  end

  it "handles non-JSON body" do
    response = described_class.new(502, {}, "Bad Gateway")

    expect(response.status_code).to eq(502)
    expect(response.json).to be_nil
    expect(response.body).to eq("Bad Gateway")
  end

  it "handles empty body" do
    response = described_class.new(204, {}, "")

    expect(response.status_code).to eq(204)
    expect(response.json).to be_nil
    expect(response.body).to eq("")
  end
end
