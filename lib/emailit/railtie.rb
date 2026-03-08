# frozen_string_literal: true

require_relative "delivery_method"

module Emailit
  class Railtie < Rails::Railtie
    initializer "emailit.add_delivery_method" do
      ActiveSupport.on_load(:action_mailer) do
        ActionMailer::Base.add_delivery_method(:emailit, Emailit::DeliveryMethod)
      end
    end
  end
end
