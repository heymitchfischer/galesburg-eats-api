class BusinessUsersController < ApplicationController
  before_action :authenticate_business_user!

  def auto_sign_in
    if current_business_user
      render status: 201, json: current_business_user
    else
      render status: 401, json: { response: "Access denied." }
    end
  end
end
