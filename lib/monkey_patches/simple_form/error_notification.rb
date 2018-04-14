module SimpleForm
  class ErrorNotification
    def render
      if has_errors?
        content = [
          template.content_tag(:p, error_message),
          object.errors[:base].map { |e| template.content_tag(:div, e, class: "error") }
        ].flatten.compact.join.html_safe

        template.content_tag(error_notification_tag, content, html_options)
      end
    end

    protected

    def errors
      object.errors
    end

    def has_errors?
      object && object.respond_to?(:errors) && errors
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
