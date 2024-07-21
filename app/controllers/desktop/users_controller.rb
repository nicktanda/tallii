module Desktop
  class UsersController < DesktopController
    def index
      @users = current_organisation.users.joins(:pets)
    end
  end
end