class ServiceWorkerController < ApplicationController
  protect_from_forgery except: :service_worker

  skip_before_action :require_authenticated_user
  skip_before_action :require_pet

  def service_worker
  end

  def manifest
  end
end