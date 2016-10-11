require 'minitest/autorun'
require 'product'

class TestProduct < Minitest::Test
  def test_find_by_product_code
    product_hash = { product_code: 'VOUCHER', price: 5 }
    assert_equal product_hash, Product.find_by_product_code('VOUCHER')
  end

  def test_find_by_product_code_not_found_nil
    assert_equal nil, Product.find_by_product_code('NECKTIE')
  end
end
