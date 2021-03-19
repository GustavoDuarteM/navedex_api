class SignUpsController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload)
      render json: { jwt: session.login[:access] }
    else
      render json: { error: user.errors.full_messages.join(' ,') }, status: :unprocessable_entity
    end
  rescue
    render json: { error: 'This email is already registered' }, status: :unprocessable_entity
  end

  private 
  def user_params
    params.permit(:email, :password)
  end
end
