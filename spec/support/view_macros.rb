# frozen_string_literal: true

module ViewMacros
  def login_member
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:member))
    end
  end

  def login_writer
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:writer))
    end
  end

  def login_editor
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:editor))
    end
  end

  def login_admin
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:admin))
    end
  end

  def login_root
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:root))
    end
  end
end
