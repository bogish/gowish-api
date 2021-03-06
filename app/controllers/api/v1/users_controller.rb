module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :doorkeeper_authorize!, only: %i(index show)

      api :GET, '/users'
      def index
        render json: user_repository.all
      end

      api :GET, '/users/:id'
      param :id, String, required: true, desc: 'id of the requested user'
      def show
        render json: user.secure_attributes
      end

      private

      def user
        @user ||= user_factory.find(params[:id])
      end


      def user_factory
        @user_factory ||= FactoryRegistry.for(:user)
      end

      def user_repository
        @user_repository ||= RepositoryRegistry.for(:users)
      end
    end
  end
end
