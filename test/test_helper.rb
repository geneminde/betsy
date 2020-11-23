ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require 'minitest/autorun'
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
        provider: user.provider,
        uid: user.uid,
        info: {
            email: user.email,
            name: user.username
        }
    }
  end

  def perform_login(user = nil)
    user ||= User.first

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get omniauth_callback_path(:github)

    user = User.find_by(uid: user.uid)
    return user
  end

  def create_cart(product = nil)
    product ||= products(:product3)

    product_id = product.id
    item_quantity = 10

    product_info = {
      "product_id": product_id,
      "quantity": item_quantity
    }

    post order_items_path, params: product_info

    active_cart = Order.find_by(id: session[:order_id])
    return active_cart
  end
end
