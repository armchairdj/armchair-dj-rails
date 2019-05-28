# frozen_string_literal: true

module ViewMacros
  def login_member
    before do
      allow(view).to receive(:current_user).and_return(create(:member))
    end
  end

  def login_writer
    before do
      allow(view).to receive(:current_user).and_return(create(:writer))
    end
  end

  def login_editor
    before do
      allow(view).to receive(:current_user).and_return(create(:editor))
    end
  end

  def login_admin
    before do
      allow(view).to receive(:current_user).and_return(create(:admin))
    end
  end

  def login_root
    before do
      allow(view).to receive(:current_user).and_return(create(:root))
    end
  end
end
