require_relative 'product'
require_relative 'pricing_rule'
require_relative 'cashier'
# Main file - It takes a set of pricing rules and applies them
# to a set of scanned products to get the total price
class Checkout
  def initialize(pricing_rules = [])
    @scanned_products = []
    @rules = pricing_rules
  end

  def scan(product_code)
    @scanned_products << product_code
  end

  def total
    cashier = Cashier.new(@scanned_products, @rules)
    cashier.calculate_total
  end
end
