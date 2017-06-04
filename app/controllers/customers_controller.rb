class CustomersController < ApplicationController
    def index
    @query = params[:query]
    @customers = Customer.search("*#{@query}*").records if @query
    @customers ||= Customer
    @customers = @customers.paginate(page: params[:page])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to :customers
    else
      render 'new'
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      redirect_to :customers
    else
      render 'edit'
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to :customers
  end

  def autocomplete
    customers = Customer.search("*#{params[:query]}*")
    render \
      json: customers.records.map{ |c| { id: c.id, text: c.name_with_company } }
  end

  def suggestions
    suggestions = Customer.suggest(params[:query])
    options = suggestions['suggestions'][0]['options']
    render json: options.map { |s| s['text'] }.uniq
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :company_id)
  end
end