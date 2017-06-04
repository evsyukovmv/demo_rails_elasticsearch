class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def search_records
    @query = params[:query]
    records = model_class
    records = records.search("*#{@query}*").records if @query.present?
    records.paginate(page: params[:page])
  end

  def suggest_records
    suggestions = model_class.suggest(params[:query])
    options = suggestions['suggestions'][0]['options']
    options.map { |s| s['text'] }.uniq
  end

  def model_class
    controller_name.classify.constantize
  end
end
