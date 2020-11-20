class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::MimeResponds
  respond_to :json

  private

  # def authenticate_user!
  #   return unless cookies.signed[:jwt] && request.headers['Jwt-Auth']

  #   token = cookies.signed[:jwt]
  #   aud = request.headers['Jwt-Auth']

  #   user = Warden::JWTAuth::UserDecoder.new.call(token, :user, aud)
  #   sign_in(:user, user)
  # end
end
