# frozen_string_literal: true

class NewsController < ApplicationController
  def sentiment_for_news
    tm = TextMood.new(language: "en")
    response = HTTParty.get("https://newsapi.org/v2/everything?q=#{params[:search_term]}&from=#{Date.yesterday}&to=#{Date.today}&sortBy=popularity&apiKey=#{Rails.application.credentials.dig(:news_api_key)}")
    articles = JSON.parse(response.body).dig("articles")
    headlines = articles.map { |article| { headline: article["title"], sentiment_score: tm.analyze(article["title"]) } }
    render json: headlines
  rescue StandardError
    render json: []
  end
end
