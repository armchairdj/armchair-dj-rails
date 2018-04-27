# frozen_string_literal: true

module ControllerMacros
  def login_member
    before(:each) do
      user = FactoryBot.create(:member)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end

  def login_contributor
    before(:each) do
      user = FactoryBot.create(:contributor)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end

  def login_admin
    before(:each) do
      user = FactoryBot.create(:admin)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end
end
