class OffersController < ApplicationController
  def index
    @offers = params[:query].present? ? Offer.search(params[:query]) : Offer
    @offers = @offers.paginate(page: params[:page])
  end

  def autocomplete
    suggestions = Offer.suggest(params[:query])
    options = suggestions['suggestions'][0]['options']
    render json: options.map { |s| s['text'] }.uniq
  end
end
