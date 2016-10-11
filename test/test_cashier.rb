require 'minitest/autorun'
require 'cashier'

class TestCashier < Minitest::Test
  def test_calculate_total
    scanned_products = %w(VOUCHER VOUCHER TSHIRT)
    rules = [{ product_code: 'VOUCHER', rule_code: '2X1' }]
    cashier = Cashier.new(scanned_products, rules)
    assert_equal cashier.calculate_total, 25
  end
end
