module Desktop
  module Users
    class CustomersController < DesktopController
      require 'csv'

      before_action :users

      def index
        @users = if params[:phone].present?
          current_organisation.users.customers.where("phone like ?", "%#{params[:phone]}%")
        else
          current_organisation.users.customers
        end
      end

      def show
        @user = users.find(params[:id])
        @users = if params[:phone].present?
          current_organisation.users.customers.where("phone like ?", "%#{params[:phone]}%")
        else
          current_organisation.users.customers
        end
      end

      def edit
        @user = users.find(params[:id])
        @users = if params[:phone].present?
          current_organisation.users.customers.where("phone like ?", "%#{params[:phone]}%")
        else
          current_organisation.users.customers
        end
      end

      def booking_settings
        @user = users.find(params[:id])
      end

      def new; end

      private

      def users
        @users ||= current_organisation.users.customers
      end
    end
  end
end