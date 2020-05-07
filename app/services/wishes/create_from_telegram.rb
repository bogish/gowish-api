module Wishes
  class CreateFromTelegram < ApplicationService
    option :telegram_user, {} do
      option :chat_id
      option :username, optional: true
      option :firstname, optional: true
      option :lastname, optional: true
    end
    option :wish, {} do
      option :body
      option :url, optional: true
    end

    def call
      Create.call(user, wish: wish.to_h.symbolize_keys)
    end

    private

    def user
      @user ||= user_factory.find_or_create_from_telegram(telegram_user.to_h.symbolize_keys)
    end

    def user_factory
      @user_factory ||= FactoryRegistry.for(:user)
    end
  end
end