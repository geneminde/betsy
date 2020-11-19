require "test_helper"

describe OrdersController do
  describe 'show' do
    it 'it gets the show page when an active cart.html.erb exists' do

    end

    it 'it gets an emtpy cart.html.erb page' do

    end
  end

  describe 'edit' do
    it 'gets the checkout page if there are items in the cart.html.erb' do

    end

    it 'redirects to the root_path if there are no items in the cart.html.erb' do

    end
  end

  describe 'update' do
    it 'updates the order with with a valid post request' do

    end

    it 'respond with not_found for invalid order ids' do

    end

    it 'will not update the order for invalid inputs' do

    end
  end

  describe 'confirmation' do
    it 'shows the confirmation page for a successful transaction' do

    end

    it 'redirects to root_path if a transaction is unsuccessful' do

    end
  end
end