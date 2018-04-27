# frozen_string_literal: true

module LayoutHelper
  def body_classes
    join_class_names (@admin ? "admin" : "public")
  end

  def copyright_notice(english: false)
    start       = "1996"
    now         = DateTime.now.strftime "%Y"
    daterange   = start == now ? start : "#{start}-#{now}"
    declaration = english ? "Copyright" : "&copy;"

    "#{declaration} #{daterange} #{t("site.owner")}".html_safe
  end

  def join_class_names(*args)
    attr = [args].flatten.compact.join(" ").gsub(/\s+/, " ").strip.split(" ").uniq.sort.join(" ")

    attr.blank? ? nil : attr
  end

  def page_container_classes
    join_class_names @page_container_class
  end

  def page_container_tag
    @page_container || :article
  end

  def page_title
    return t("site.name_with_tagline") if @homepage

    raise NoMethodError.new(t("exceptions.helpers.layout.title.missing")) unless @title

    [t("site.name"), @title].flatten.compact.join(" | ")
  end

  def site_logo
    image_tag("armchair.jpg", class: "chair", alt: "#{t("site.name")} logo")
  end

  def wrapper_classes
    join_class_names "wrapper", (@admin ? "admin" : "public")
  end
end
