class PricingRule

  # Available pricing rules with a method for the calculation
  PRICING_RULES = [
    { rule_code: "2X1", pricing_method: :free_2nd_unit },
    { rule_code: "BULK", pricing_method: :bulk_discount }
  ]

  def initialize(applicable_rule, product_qty)
    @selected_rule = PRICING_RULES.find{ |dr| dr[:rule_code] == applicable_rule[:rule_code] }
    @rule_options = applicable_rule[:rule_options]
    @product = Product.find_by_product_code(applicable_rule[:product_code])
    @product_qty = product_qty
  end

  # Use the rule's pricing method to calculate custom price
  # Return nil if the rule isn't defined - Regular price will be used instead
  def calculate_custom_price
    public_send(@selected_rule[:pricing_method]) unless @selected_rule.nil? || @product.nil?
  end

  def free_2nd_unit
    if @product_qty >= 2
      # Charge only one unit each two, charge the remainder in case of odd number
      (@product_qty/2 + @product_qty%2) * @product[:price]
    else
      @product_qty * @product[:price]
    end
  end

  def bulk_discount
    if @product_qty >= 3
      # Charge using bulk price if present, otherwise use regular price
      @product_qty * (@rule_options[:bulk_price] || @product[:price])
    else
      @product_qty * @product[:price]
    end
  end

end
