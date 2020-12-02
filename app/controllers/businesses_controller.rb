class BusinessesController < ApplicationController
  def index
    @businesses = Business.all
  end

  def show
    unless business
      render json: { error: 'No business exists at that slug' }, status: 404
    end
  end

  private

  def business
    @business ||= Business.find_by_slug(params[:slug])
  end
end
