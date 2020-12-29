class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::MimeResponds
  respond_to :json

  private

  def current_or_guest_user
    @current_or_guest_user ||=
      if current_user
        current_user
      elsif cookies.signed[:guest_user_id].present?
        GuestUser.new(cookies.signed[:guest_user_id])
      else
        cookies.signed[:guest_user_id] = generate_guest_user_id
        GuestUser.new(cookies.signed[:guest_user_id])
      end
  end

  def generate_guest_user_id
    loop do
      uuid = SecureRandom.base64(12)
      break uuid unless CartedItem.where(guest_user_id: uuid).any? || Order.where(guest_user_id: uuid).any?
    end
  end

  # def authenticate_user!
  #   return unless cookies.signed[:jwt] && request.headers['Jwt-Auth']

  #   token = cookies.signed[:jwt]
  #   aud = request.headers['Jwt-Auth']

  #   user = Warden::JWTAuth::UserDecoder.new.call(token, :user, aud)
  #   sign_in(:user, user)
  # end

  def transfer_guest_items_to_user
    return unless cookies.signed[:guest_user_id].present? && current_user

    guest_user = GuestUser.new(cookies.signed[:guest_user_id])
    cart = Cart.new(guest_user)

    cart.transfer_ownership_of_current_items_to(current_user)
    # TODO: Decide if we need to clear the cookies here
    # cookies.delete(:guest_user_id)
  end
end
