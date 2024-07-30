module Desktop
  class DesktopController < ApplicationController
    layout "desktop"

    skip_before_action :require_pet
  end
end