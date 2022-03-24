class BusinessesController < ApplicationController
  before_action :authenticate_business_user!, except: [:index, :show]

  def index
    @businesses = Business.all
  end

  def show
    unless business
      render json: { error: 'No business exists at that slug' }, status: 404
    end
  end

  def create
    begin
      @business = Business.new(business_create_params)

      if @business.save
        BusinessUserConnection.create(business_user_id: current_business_user.id,
                                      business_id: @business.id,
                                      role: :owner)
        render 'show', status: 201
      else
        render json: { error: @business.errors.full_messages }, status: 409
      end
    rescue => error
      render json: { error: error.message }, status: 500
    end
  end

  def update_image
    # TODO: Check that current business user has access to this resource
    begin
      business.thumbnail_image.attach(params[:thumbnail_image])
      render 'show', status: 200
    rescue => error
      render json: { error: error.message }, status: 500
    end
  end

  private

  def business
    @business ||= Business.find_by_slug(params[:slug])
  end

  def business_create_params
    params.require(:business).permit(:name, :address, :description, :slug)
  end
end
