class UsersController < ApplicationController
  before_action :authenticate_user!

  def auto_sign_in
    if current_user
      render status: 201, json: current_user
    else
      render status: 401, json: { response: "Access denied." }
    end
  end
end
