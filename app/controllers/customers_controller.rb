class CustomersController < ApplicationController
  def autocomplete
    customers = Customer.search("*#{params[:query]}*")
    render \
      json: customers.records.map{ |c| { id: c.id, text: c.name_with_company } } 
  end
end