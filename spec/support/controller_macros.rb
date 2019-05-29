# frozen_string_literal: true

module ControllerMacros
  def login_member
    before do
      user = FactoryBot.create(:member)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end

  def login_writer
    before do
      user = FactoryBot.create(:writer)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end

  def login_editor
    before do
      user = FactoryBot.create(:editor)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end

  def login_admin
    before do
      user = FactoryBot.create(:admin)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end

  def login_root
    before do
      user = FactoryBot.create(:root)

      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in user
    end
  end
end
