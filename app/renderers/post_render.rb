class PostRender < Redcarpet::Render::HTML
  include ActionView::Helpers::UrlHelper

  INTERNAL_REGEXP = /^internal:/.freeze
  LINK_REGEXP     = /^internal:(\w+)\/(\d+)/.freeze

  def link(url, title, content)
    link_to(content.html_safe, normalize_url(url), title: title)
  rescue => err
    log_render_error(err, { url: url, content: content })

    content.html_safe
  end

private

  def log_render_error(err, params)
    msg = "Failed to render markdown link with params #{params.inspect}."

    Rails.logger.error [err.class, msg, err.message].join(": ")
  end

  def normalize_url(url)
    is_internal_url(url) ? transform_internal_url(url) : url
  end

  def is_internal_url(url)
    url.match(INTERNAL_REGEXP)
  end

  def transform_internal_url(url)
    match, model_name, id = url.match(LINK_REGEXP).to_a

    raise ArgumentError unless model_name && id

    url_helper(model_name, id)
  end

  def url_helper(model_name, id)
    post   = find_published_post(model_name, id)
    method = :"#{model_name}_path"

    Rails.application.routes.url_helpers.send(method, post.slug)
  end

  def find_published_post(model_name, id)
    model_class = model_name.singularize.capitalize.constantize

    model_class.published.find(id)
  end
end
