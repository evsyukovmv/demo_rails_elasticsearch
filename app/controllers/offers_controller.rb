class OffersController < ApplicationController
  def index
    @offers = search_records
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to :root
    else
      render 'new'
    end
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])
    if @offer.update_attributes(offer_params)
      redirect_to :root
    else
      render 'edit'
    end
  end

  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy
    redirect_to :root
  end

  def suggestions
    render json: suggest_records
  end

  private

  def offer_params
    params.require(:offer).permit(:title, :description, :customer_id)
  end
end
