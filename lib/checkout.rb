require_relative 'product'
require_relative 'pricing_rule'
require_relative 'cashier'
# Main file - It takes a set of pricing rules and applies them
# to a set of scanned products to get the total price
class Checkout
  # Example of the expected param
  # pricing_rules = [
  #   { product_code: 'VOUCHER', rule_code: '2X1' },
  #   { product_code: 'TSHIRT', rule_code: 'BULK',
  #     rule_options: { bulk_price: 19 } }
  # ]
  def initialize(pricing_rules = [])
    @scanned_products = []
    @rules = pricing_rules
  end

  # Expected param 'VOUCHER'
  def scan(product_code)
    return if Product.find_by_product_code(product_code).nil?

    @scanned_products << product_code
  end

  def total
    cashier = Cashier.new(@scanned_products, @rules)
    cashier.calculate_total
  end
end
