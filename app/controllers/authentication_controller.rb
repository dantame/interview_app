# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def create
    @user = User.new(username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation])

    if @user.save
      self.authenticate()
    else
      render json: { error: "Unable to create user" }, status: :unauthorized
    end
  end

  def authenticate
    command = AuthenticateUser.call(params[:username], params[:password])

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
