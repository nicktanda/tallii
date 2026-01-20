module Desktop
  module Users
    class CustomersController < DesktopController
      require 'csv'

      before_action :users
      before_action :set_paginated_users, only: [:index, :show, :edit]

      PER_PAGE = 50

      def index; end

      def show
        @user = users.find(params[:id])
      end

      def edit
        @user = users.find(params[:id])
      end

      def booking_settings
        @user = users.find(params[:id])
      end

      def new; end

      private

      def users
        @users ||= current_organisation.users.customers
      end

      def set_paginated_users
        base_scope = if params["phone"].present?
          users.where("phone LIKE ?", "%#{params["phone"]}%")
        else
          users
        end

        @page = [params[:page].to_i, 1].max
        @total_count = base_scope.count
        @total_pages = (@total_count.to_f / PER_PAGE).ceil
        @users = base_scope.order(:last_name, :first_name).limit(PER_PAGE).offset((@page - 1) * PER_PAGE)
      end
    end
  end
end