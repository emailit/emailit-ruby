# frozen_string_literal: true

require "base64"

module Emailit
  class DeliveryMethod
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
      raise ArgumentError, "Emailit API key is required. Set config.action_mailer.emailit_settings = { api_key: 'your_key' }" unless @settings[:api_key]

      @client = EmailitClient.new(@settings[:api_key])
    end

    def deliver!(mail)
      params = build_params(mail)
      @client.emails.send(params)
    end

    private

    def build_params(mail)
      params = {}

      params["from"] = mail.from&.first || mail[:from]&.to_s
      params["to"] = Array(mail.to)
      params["subject"] = mail.subject if mail.subject

      if mail.cc && !mail.cc.empty?
        params["cc"] = Array(mail.cc)
      end

      if mail.bcc && !mail.bcc.empty?
        params["bcc"] = Array(mail.bcc)
      end

      if mail.reply_to && !mail.reply_to.empty?
        params["reply_to"] = Array(mail.reply_to).first
      end

      if mail.multipart?
        mail.parts.each do |part|
          case part.content_type
          when /text\/html/
            params["html"] = part.body.decoded
          when /text\/plain/
            params["text"] = part.body.decoded
          end
        end
      elsif mail.content_type&.include?("text/html")
        params["html"] = mail.body.decoded
      else
        params["text"] = mail.body.decoded
      end

      if mail.attachments.any?
        params["attachments"] = mail.attachments.map do |attachment|
          {
            "filename" => attachment.filename,
            "content" => Base64.strict_encode64(attachment.body.decoded),
            "content_type" => attachment.content_type.split(";").first,
          }
        end
      end

      if mail.header["X-Emailit-Tags"]
        params["tags"] = mail.header["X-Emailit-Tags"].to_s.split(",").map(&:strip)
      end

      params
    end
  end
end
