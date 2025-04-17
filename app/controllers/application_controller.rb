class ApplicationController < ActionController::API
  private
  include Rails.application.routes.url_helpers

  def authenticate_user_from_token!
    token = request.headers['Authorization']&.split(' ')&.last
    return head :unauthorized unless token

    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      @current_user = User.find(payload['sub'])
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      head :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
