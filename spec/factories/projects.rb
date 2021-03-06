FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Test Project#{n}"}
    description "Sample project for testing proposes"
    due_on 1.week.from_now
    association :owner

    trait :same_owner do
      association :owner, email: "test@example.com"
    end

    #メモ付きのプロジェクト
    trait :with_notes do
      after(:create) {|project| create_list(:note, 5, project: project)}  #noteを作るのに必要なProjectモデルの指定(project: project)
    end

    # 昨日が締め切りのプロジェクト
    trait :project_due_yesterday do
      due_on 1.day.ago
    end

    # 今日が締め切りのプロジェクト
    trait :project_due_today do
      due_on Date.current.in_time_zone
    end

    # 明日が締め切りのプロジェクト
    trait :project_due_tomorrow do
      due_on 1.day.from_now
    end
  end
end
