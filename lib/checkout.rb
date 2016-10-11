require_relative 'product'
require_relative 'pricing_rule'
require_relative 'cashier'
# Main file - It takes a set of pricing rules and applies them
# to a set of scanned products to get the total price
# Assumptions:
# 1. The products and rules are stored somewhere (in this case hardcoded)
# 2. Only one rule can be applied to a product at a time
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
    # Short way to get 2 decimals and hard code the currency
    format('%.2f€', cashier.calculate_total)
  end
end
