# frozen_string_literal: true

module SimpleForm
  class ErrorNotification
    delegate :object, :object_name, :template, to: :@builder

    def initialize(builder, options)
      @builder = builder
      @message = options.delete(:message)
      @options = options
    end

    def render
      return unless errors?

      template.content_tag(error_notification_tag, error_markup, html_options)
    end

  protected

    def errors
      object.errors
    end

    def errors?
      object&.respond_to?(:errors) && errors.present?
    end

    def error_markup
      content = object.errors[:base].map { |e| template.content_tag(:div, e, class: "error") }
      content = [template.content_tag(:p, error_message)] + content

      content.compact!

      content.join.html_safe
    end

    def error_message
      (@message || translate_error_notification).html_safe
    end

    def error_notification_tag
      SimpleForm.error_notification_tag
    end

    def html_options
      @options[:class] = "#{SimpleForm.error_notification_class} #{@options[:class]}".strip

      @options
    end

    def translate_error_notification
      lookups = []

      lookups << :"#{object_name}"
      lookups << :default_message
      lookups << "Please review the problems below:"

      I18n.t(lookups.shift, scope: :"simple_form.error_notification", default: lookups)
    end
  end
end
