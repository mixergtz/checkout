class Cashier

  def initialize(scanned_products, rules)
    # Group and summarize the scanned products
    @products_summary = scanned_products.group_by{|i| i}.map{|k,v| { product_code: k, qty: v.count } }
    @rules = rules
    @total_price = 0
  end

  def calculate_total_price
    # For each product in the cart
    @products_summary.each do |product|

      # Get the regular price
      regular_price = calculate_regular_price(product[:product_code], product[:qty])

      # See which discount can be applied
      applicable_rule = get_pricing_rule_for_product(product[:product_code])

      # If a rule is present try to calculate custom price
      unless applicable_rule.nil?
        pricing_rule = PricingRule.new(applicable_rule, product[:qty])
        # Regular price will be the default
        @total_price += pricing_rule.calculate_custom_price || regular_price
      else
        @total_price += regular_price
      end
    end

    @total_price
  end

  private

  def calculate_regular_price(product_code, product_qty)
    product = Product.find_by_product_code(product_code)
    product[:price] * product_qty
  end

  # Search if a pricing rule is defined for the product
  def get_pricing_rule_for_product(product_code)
    @rules.find{ |r| r[:product_code] == product_code }
  end

end
