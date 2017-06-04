class OffersController < ApplicationController
  def index
    @query = params[:query]
    @offers = Offer.search("*#{@query}*").records if @query.present?
    @offers ||= Offer
    @offers = @offers.paginate(page: params[:page])
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
    suggestions = Offer.suggest(params[:query])
    options = suggestions['suggestions'][0]['options']
    render json: options.map { |s| s['text'] }.uniq
  end

  private

  def offer_params
    params.require(:offer).permit(:title, :description, :customer_id)
  end
end
