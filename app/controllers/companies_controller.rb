class CompaniesController < ApplicationController
  def index
    @companies = search_records
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to :companies
    else
      render 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(company_params)
      redirect_to :companies
    else
      render 'edit'
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to :companies
  end

  def autocomplete
    customers = Company.search("*#{params[:query]}*")
    render \
      json: customers.records.map{ |c| { id: c.id, text: c.name } }
  end

  def suggestions
    render json: suggest_records
  end

  private

  def company_params
    params.require(:company).permit(:name, :address)
  end
end