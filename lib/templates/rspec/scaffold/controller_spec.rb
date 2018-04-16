require "rails_helper"

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller, <%= type_metatag(:controller) %> do

  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_params) {
    skip("Add a hash of attributes invalid for your model")
  }

<% unless options[:singleton] -%>
  describe "GET #index" do
    it "renders" do
      <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
      get :index, {}
<% else -%>
      get :index, params: {}, session: valid_session
<% end -%>
      expect(response).to be_success
    end
  end

<% end -%>
  describe "GET #show" do
    it "renders" do
      <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
      get :show, {:id => <%= file_name %>.to_param}
<% else -%>
      get :show, params: {id: <%= file_name %>.to_param}, session: valid_session
<% end -%>
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "renders" do
<% if Rails::VERSION::STRING < "5.0" -%>
      get :new, {}
<% else -%>
      get :new, params: {}, session: valid_session
<% end -%>
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new <%= class_name %>" do
        expect {
<% if Rails::VERSION::STRING < "5.0" -%>
          post :create, {:<%= ns_file_name %> => valid_params}
<% else -%>
          post :create, params: {<%= ns_file_name %>: valid_params}, session: valid_session
<% end -%>
        }.to change(<%= class_name %>, :count).by(1)
      end

      it "redirects to the created <%= ns_file_name %>" do
<% if Rails::VERSION::STRING < "5.0" -%>
        post :create, {:<%= ns_file_name %> => valid_params}
<% else -%>
        post :create, params: {<%= ns_file_name %>: valid_params}, session: valid_session
<% end -%>
        expect(response).to redirect_to(<%= class_name %>.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the "new" template)" do
<% if Rails::VERSION::STRING < "5.0" -%>
        post :create, {:<%= ns_file_name %> => invalid_params}
<% else -%>
        post :create, params: {<%= ns_file_name %>: invalid_params}, session: valid_session
<% end -%>
        expect(response).to be_success
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
      get :edit, {:id => <%= file_name %>.to_param}
<% else -%>
      get :edit, params: {id: <%= file_name %>.to_param}, session: valid_session
<% end -%>
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested <%= ns_file_name %>" do
        <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
        put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => new_attributes}
<% else -%>
        put :update, params: {id: <%= file_name %>.to_param, <%= ns_file_name %>: new_attributes}, session: valid_session
<% end -%>
        <%= file_name %>.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the <%= ns_file_name %>" do
        <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
        put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => valid_params}
<% else -%>
        put :update, params: {id: <%= file_name %>.to_param, <%= ns_file_name %>: valid_params}, session: valid_session
<% end -%>
        expect(response).to redirect_to(<%= file_name %>)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the "edit" template)" do
        <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
        put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => invalid_params}
<% else -%>
        put :update, params: {id: <%= file_name %>.to_param, <%= ns_file_name %>: invalid_params}, session: valid_session
<% end -%>
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested <%= ns_file_name %>" do
      <%= file_name %> = <%= class_name %>.create! valid_params
      expect {
<% if Rails::VERSION::STRING < "5.0" -%>
        delete :destroy, {:id => <%= file_name %>.to_param}
<% else -%>
        delete :destroy, params: {id: <%= file_name %>.to_param}, session: valid_session
<% end -%>
      }.to change(<%= class_name %>, :count).by(-1)
    end

    it "redirects to the <%= table_name %> list" do
      <%= file_name %> = <%= class_name %>.create! valid_params
<% if Rails::VERSION::STRING < "5.0" -%>
      delete :destroy, {:id => <%= file_name %>.to_param}
<% else -%>
      delete :destroy, params: {id: <%= file_name %>.to_param}, session: valid_session
<% end -%>
      expect(response).to redirect_to(<%= index_helper %>_url)
    end
  end

end
<% end -%>
