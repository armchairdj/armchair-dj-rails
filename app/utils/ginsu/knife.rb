# frozen_string_literal: true

module Ginsu
  class Knife
    extend UrlHelpers

    ###########################################################################
    # CLASS.
    ###########################################################################

    def self.diced_url(model_class, scope, sort, dir)
      opts = { scope: scope, sort: sort, dir: dir }

      opts.compact!

      polymorphic_path [:admin, model_class], **opts
    end

    ###########################################################################
    # ATTRIBUTES.
    ###########################################################################

    attr_reader :current_scope
    attr_reader :current_sort
    attr_reader :current_dir

    ###########################################################################
    # INSTANCE.
    ###########################################################################

    def initialize(current_scope: nil, current_sort: nil, current_dir: nil)
      @current_scope = current_scope
      @current_sort  = current_sort
      @current_dir   = current_dir
    end

    private

    def diced_url(*args)
      self.class.diced_url(model_class, *args)
    end

    def validate
      return if valid?

      raise Pundit::NotAuthorizedError, invalid_msg
    end

    def valid?
      raise NotImplementedError
    end

    def invalid_msg
      raise NotImplementedError
    end

    def model_class
      raise NotImplementedError
    end
  end
end
