class CookiesController < ApplicationController
  before_action :authenticate_user!, except: [:validate_cookie, :remove_cookie]

  def test
    render json: { message: 'Hello world' }
  end

  def store_cookie
    begin
      token = request.headers['Authorization'].split(' ')[1]
      cookies.signed[:jwt] = { value: token, httponly: true }
      render status: 204
    rescue StandardError => error
      render status: 400, json: { errors: error }
    end
  end

  def validate_cookie
    begin
      token = cookies.signed[:jwt]
      aud = request.headers['Jwt-Auth']

      user = Warden::JWTAuth::UserDecoder.new.call(token, :user, aud)

      if user && sign_in(:user, user)
        response.headers['Authorization'] = "Bearer #{token}"
        render status: 201, json: { id: current_user.id, email: current_user.email }
      else
        render status: 401, json: { response: "Access denied." }
      end
    rescue StandardError => error
      render status: 400, json: { errors: error }
    end
  end

  def remove_cookie
    begin
      cookies.delete(:jwt)
      render status: 204
    rescue StandardError => error
      render status: 400, json: { errors: error }
    end
  end
end
