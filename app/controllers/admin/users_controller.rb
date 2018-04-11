class Admin::UsersController
  include SeoPaginatable

  after_action :verify_authorized

end
