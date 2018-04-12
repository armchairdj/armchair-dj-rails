xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title       I18n.t("site.name")
    xml.description I18n.t("site.tagline")
    xml.link        posts_url

    @posts.each do |post|
      xml.item do
        xml.title       post_title(post, full: true)
        xml.description post.body
        xml.pubDate     post.published_at.to_s(:rfc822)
        xml.link        post_permalink_path(slug: post.id)
        xml.guid        post_permalink_path(slug: post.id)
      end
    end
  end
end
