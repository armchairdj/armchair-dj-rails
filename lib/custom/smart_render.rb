# model_name.singularize.capitalize.constantize.find(id)

class SmartRender < Redcarpet::Render::HTML
  include ActionView::Helpers::UrlHelper

  def link(url, title, content)
    link_to(content.html_safe, normalize_url(url), title: title)
  rescue => err
    # TODO logging

    content
  end

  # TODO bulleted list

private

  def normalize_url(url)
    is_internal_url(url) ? handle_internal_url(url) : url
  end

  def is_internal_url(url)
    url.match(/^internal:\/\//)
  end

  def handle_internal_url(url)
    match, model_name, id = url.match(/^internal:\/\/(\w+)\/(\d+)/).to_a

    raise ArgumentError unless model_name && id

    model_class = model_name.singularize.capitalize.constantize
    instance    = model_class.published.find(id)
    routes      = Rails.application.routes.url_helpers
    url         = routes.send(:"#{model_name}_path", instance.slug)
  end
end
