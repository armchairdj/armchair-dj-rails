# frozen_string_literal: true

module Posts
  class PublicController < ApplicationController
    include Paginatable

    # GET /<plural_param_key>
    # GET /<plural_param_key>.json
    def index
      set_section

      authorize_model

      @collection = find_collection
    end

    # GET /<plural_param_key>/friendly_id
    # GET /<plural_param_key>/friendly_id.json
    def show
      set_section

      @post = @instance = find_instance

      authorize @instance

      @meta_description = @instance.summary
    end

    private

    def find_collection
      collection = policy_scope(@model_class).for_list.page(params[:page])

      instance_variable_set(:"@#{controller_name}", collection)

      collection
    end

    def find_instance
      instance = policy_scope(@model_class).for_show.find_by!(slug: params[:slug])

      instance_variable_set(:"@#{controller_name.singularize}", instance)

      instance
    end

    def set_section
      raise NotImplementedError
    end

    def determine_layout
      return "post" if action_name == "show"

      "public"
    end
  end
end
