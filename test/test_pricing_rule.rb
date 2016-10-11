require 'minitest/autorun'
require 'pricing_rule'

class TestPricingRule < Minitest::Test
  def test_calculate_custom_price
    applicable_rule = { product_code: 'VOUCHER', rule_code: '2X1' }
    product_qty = 3
    pricing_rule = PricingRule.new(applicable_rule, product_qty)
    assert_equal pricing_rule.calculate_custom_price, 10
  end

  def test_rule_pricing_method_called
    applicable_rule = { product_code: 'VOUCHER', rule_code: '2X1' }
    product_qty = 3
    pricing_rule = PricingRule.new(applicable_rule, product_qty)
    assert_send([pricing_rule, :free_2nd_unit])
    pricing_rule.calculate_custom_price
  end
end
