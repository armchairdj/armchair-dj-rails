# frozen_string_literal: true

module Admin
  module Posts
    class ArticlesController < Admin::Posts::BaseController
      private

      def keys_for_create
        [:title]
      end

      # TODO: BJD Find a more elegant way to include extra permitted
      # params for particular post types
      def keys_for_update
        [:body, :summary, :hero_image, {
          additional_images: [],
          tag_ids:           [],
          links_attributes:  [:id, :_destroy, :url, :description]
        }]
      end
    end
  end
end
