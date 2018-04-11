class AdminController < ApplicationController
  include SeoPaginatable

  prepend_before_action :is_admin

  after_action :verify_authorized
end
