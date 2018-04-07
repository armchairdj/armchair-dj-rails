class AdminController < ApplicationController
  prepend_before_action :is_admin
end
