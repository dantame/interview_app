# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { "test" }
    password  { "test" }
    password_confirmation { "test" }
  end
end
