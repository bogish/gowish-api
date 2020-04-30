module Telegram
  class Auth < ApplicationService
    option :auth_data
    option :secure_hash

    def call
      return user if check_hash == secure_hash
    end

    private

    def user
      @user ||= user_factory.find_or_create_from_telegram(
        chat_id: auth_data[:id],
        username: auth_data[:username],
        firstname: auth_data[:first_name],
        lastname: auth_data[:last_name]
      )
    end

    def check_hash
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret_key, data_string)
    end

    def data_string
      auth_data.sort.map { |v| v.join('=') }.join("\n")
    end

    def secret_key
      OpenSSL::Digest::SHA256.new.digest(Rails.application.credentials.telegram[:token])
    end

    def user_factory
      @user_factory ||= FactoryRegistry.for(:user)
    end
  end
end
