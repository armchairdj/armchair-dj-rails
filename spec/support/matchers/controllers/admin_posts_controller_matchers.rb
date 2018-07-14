# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_the_post_form do |param_key|
  match do
    case param_key
    when :article; is_expected.to prepare_the_article_form
    when :review;  is_expected.to prepare_the_review_form
    when :mixtape; is_expected.to prepare_the_mixtape_form
    end
  end

  failure_message do
    "expected to prepare the #{param_key} form, but did not"
  end
end

RSpec::Matchers.define :prepare_the_article_form do
  match do
    expect(assigns(:tags)).to be_a_kind_of(ActiveRecord::Relation)
  end

  failure_message do
    "expected to prepare the article form, but did not"
  end
end

RSpec::Matchers.define :prepare_the_review_form do
  match do
    expect(assigns(:tags )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:works)).to be_a_kind_of(Array)
  end

  failure_message do
    "expected to prepare the review form, but did not"
  end
end

RSpec::Matchers.define :prepare_the_mixtape_form do
  match do
    expect(assigns(:tags     )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:playlists)).to be_a_kind_of(ActiveRecord::Relation)
  end

  failure_message do
    "expected to prepare the mixtape form, but did not"
  end
end
