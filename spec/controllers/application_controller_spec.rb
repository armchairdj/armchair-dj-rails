# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "concerns" do
    it_behaves_like "an_errorable_controller"

    pending "pundit"
  end

  describe "included" do
    pending "protect_from_forgery"
    pending "add_flash_types"

    describe "callbacks" do
      pending "determine_layout"
    end
  end

  describe "instance" do
    describe "protected" do
      pending "#after_sign_in_path_for"
      pending "#after_sign_out_path_for"
      pending "#model_class"
    end

    describe "private" do
      describe "#determine_layout" do
        specify { expect(controller.send(:determine_layout)).to eq("public") }
      end

      pending "#authorize_model"
    end
  end
end
