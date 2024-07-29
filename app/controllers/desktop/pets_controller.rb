module Desktop
  class PetsController < DesktopController
    def new
      @user = current_organisation.users.find(params[:id])
    end
  end
end