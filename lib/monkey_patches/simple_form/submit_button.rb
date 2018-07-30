module SimpleForm
  class FormBuilder
    def submit_button(*args, &block)
      ActionController::Base.helpers.content_tag(:div, class: 'form-actions') do
        submit(*args, &block)
      end
    end
  end
end
