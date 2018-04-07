FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :standalone_post_title do |n|
    "Naked Post Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :post do
    factory :standalone_post do
      title { generate(:standalone_post_title) }
      body "This is come content."

      factory :minimal_post do
        # Just a naked post.
      end
    end

    factory :work_post do
      body "This is a post about a work."
      association :work, factory: :minimal_work
    end
  end
end
