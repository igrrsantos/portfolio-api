FactoryBot.define do
  factory :tech_tag do
    name { Faker::ProgrammingLanguage.name }
  end
end
