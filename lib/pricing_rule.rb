# Holds Pricing Rules and the custom implementation for each one
# Adding a new rule here with a complying method will suffice
# to have a new working rule
class PricingRule
  # Available pricing rules and the name of the custom method
  PRICING_RULES = [
    { rule_code: '2X1', pricing_method: :free_2nd_unit },
    { rule_code: 'BULK', pricing_method: :bulk_discount }
  ].freeze

  def initialize(applicable_rule, product_qty)
    @selected_rule = PRICING_RULES.find { |pr| pr[:rule_code] == applicable_rule[:rule_code] }
    @rule_options = applicable_rule[:rule_options] || {}

    @product = Product.find_by_product_code(applicable_rule[:product_code])
    @product_qty = product_qty
  end

  # Use the rule's pricing method to calculate custom price
  # Return nil if the rule isn't defined - Regular price will be used instead
  def calculate_custom_price
    return nil if @selected_rule.nil? || @product.nil?

    public_send(@selected_rule[:pricing_method])
  end

  # Implementation methods for defined rules
  # The method should return the value to be added to the total
  # for a set of items of the same type

  def free_2nd_unit
    return @product_qty * @product[:price] if @product_qty < 2

    # Calculate only one unit each two and remainder in case of odd number
    (@product_qty / 2 + @product_qty % 2) * @product[:price]
  end

  def bulk_discount
    return @product_qty * @product[:price] if @product_qty < 3

    # Calculate using bulk price if present, otherwise use regular price
    @product_qty * (@rule_options[:bulk_price] || @product[:price])
  end
end
