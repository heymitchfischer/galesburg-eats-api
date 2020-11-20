class BusinessesController < ApplicationController
  def index
    @businesses = Business.all

    render json: { businesses: @businesses }, status: 200
  end

  def show
    @business = Business.find_by_slug(params[:slug])

    render json: { business: @business }, status: 200
  end
end
