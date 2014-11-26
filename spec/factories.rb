FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :idea do
    content "Lorem ipsum"
    user
  end

  factory :like do
    association :idea
    association :user
  end

  factory :group do
  end

  factory :asset do
    file { File.new(Rails.root.join('app', 'assets', 'images', 'rails.png')) }
  end

  factory :join_request do
    association :idea
    association :to_idea, factory: :idea
  end
end
