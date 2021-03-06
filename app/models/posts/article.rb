# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  alpha        :string
#  body         :text
#  publish_on   :datetime
#  published_at :datetime
#  slug         :string
#  status       :integer          default("draft"), not null
#  summary      :text
#  title        :string
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint(8)
#  playlist_id  :bigint(8)
#  work_id      :bigint(8)
#
# Indexes
#
#  index_posts_on_alpha        (alpha)
#  index_posts_on_author_id    (author_id)
#  index_posts_on_playlist_id  (playlist_id)
#  index_posts_on_slug         (slug) UNIQUE
#  index_posts_on_status       (status)
#  index_posts_on_type         (type)
#  index_posts_on_work_id      (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (playlist_id => playlists.id)
#  fk_rails_...  (work_id => works.id)
#

class Article < Post
  concerning :Alphabetization do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [title]
    end
  end

  concerning :ImageAttachment do
    included do
      include Imageable
    end
  end

  concerning :PublicSite do
    def related_posts
      super.by_tag(tags)
    end
  end

  concerning :SlugAttribute do
    def sluggable_parts
      [title]
    end
  end

  concerning :StiInheritance do
    def display_type(plural: false)
      plural ? "Articles" : "Article"
    end
  end

  concerning :TitleAttribute do
    included do
      validates :title, presence: true
    end
  end
end
