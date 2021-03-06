# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
  post "create", to: "authentication#create"
  get "headlines", to: "news#sentiment_for_news"
end
