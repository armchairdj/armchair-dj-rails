# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :prepare_the_article_form do
  match do
    expect(assigns(:tags)).to be_a_kind_of(ActiveRecord::Relation)
  end

  match_when_negated do
    expect(assigns(:tags)).to eq(nil)
  end

  failure_message do
    "expected to prepare the article form, but did not"
  end

  failure_message_when_negated do
    "expected not to prepare article form, but did"
  end
end

RSpec::Matchers.define :prepare_the_review_form do
  match do
    expect(assigns(:tags )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:works)).to be_a_kind_of(Array)
  end

  match_when_negated do
    expect(assigns(:tags )).to eq(nil)
    expect(assigns(:works)).to eq(nil)
  end

  failure_message do
    "expected to prepare the review form, but did not"
  end

  failure_message_when_negated do
    "expected not to prepare review form, but did"
  end
end

RSpec::Matchers.define :prepare_the_mixtape_form do
  match do
    expect(assigns(:tags     )).to be_a_kind_of(ActiveRecord::Relation)
    expect(assigns(:playlists)).to be_a_kind_of(ActiveRecord::Relation)
  end

  match_when_negated do
    expect(assigns(:tags     )).to eq(nil)
    expect(assigns(:playlists)).to eq(nil)
  end

  failure_message do
    "expected to prepare the mixtape form, but did not"
  end

  failure_message_when_negated do
    "expected not to prepare mixtape form, but did"
  end
end
