module AllowlistRevocation
  extend ActiveSupport::Concern

  included do
    # @see Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoked?
    def self.jwt_revoked?(payload, user)
      !user.allowlisted_jwts.exists?(payload.slice('jti', 'aud'))
    end

    # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
    def self.revoke_jwt(payload, user)
      jwt = user.allowlisted_jwts.find_by(payload.slice('jti', 'aud'))
      jwt.destroy! if jwt
    end
  end

  # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
  def on_jwt_dispatch(_token, payload)
    remove_duplicate_jwts(payload['aud'])

    allowlisted_jwts.create!(
      jti: payload['jti'],
      aud: payload['aud'],
      exp: Time.at(payload['exp'].to_i)
    )
  end

  def remove_duplicate_jwts(aud)
    allowlisted_jwts.where(aud: aud).destroy_all
  end

  def signed_in?
    allowlisted_jwts.any?
  end
end
