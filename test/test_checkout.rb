require 'minitest/autorun'
require 'checkout'

describe Checkout do
  describe 'with a set of rules' do
    before do
      pricing_rules = [
        { product_code: 'VOUCHER', rule_code: '2X1' },
        { product_code: 'TSHIRT', rule_code: 'BULK',
          rule_options: { bulk_price: 19 } }
      ]
      @co = Checkout.new(pricing_rules)
    end

    it 'returns the right value for a VOUCHER, TSHIRT and MUG' do
      @co.scan('MUG')
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.total.must_equal '32.50€'
    end

    it 'returns the right value for 2 VOUCHER and a TSHIRT' do
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.scan('VOUCHER')
      @co.total.must_equal '25.00€'
    end

    it 'returns the right value for 4 TSHIRT and a VOUCHER' do
      @co.scan('TSHIRT')
      @co.scan('TSHIRT')
      @co.scan('TSHIRT')
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.total.must_equal '81.00€'
    end

    it 'returns the right value for 3 TSHIRT, 3 VOUCHER and a MUG' do
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.scan('VOUCHER')
      @co.scan('VOUCHER')
      @co.scan('MUG')
      @co.scan('TSHIRT')
      @co.scan('TSHIRT')
      @co.total.must_equal '74.50€'
    end
  end

  describe 'without a set of rules' do
    before do
      @co = Checkout.new
    end

    it 'returns the right value for a VOUCHER, TSHIRT and MUG' do
      @co.scan('MUG')
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.total.must_equal '32.50€'
    end

    it 'returns the right value for 2 VOUCHER and a TSHIRT' do
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.scan('VOUCHER')
      @co.total.must_equal '30.00€'
    end
  end

  describe 'with one rule' do
    before do
      pricing_rules = [{ product_code: 'VOUCHER', rule_code: '2X1' }]
      @co = Checkout.new(pricing_rules)
    end

    it 'returns the right value for a VOUCHER, TSHIRT and MUG' do
      @co.scan('MUG')
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.total.must_equal '32.50€'
    end

    it 'returns the right value for 2 VOUCHER and a TSHIRT' do
      @co.scan('VOUCHER')
      @co.scan('TSHIRT')
      @co.scan('VOUCHER')
      @co.total.must_equal '25.00€'
    end
  end

  describe 'with a non-existent rule' do
    it 'returns the regular value for a VOUCHER, TSHIRT and MUG' do
      pricing_rules = [{ product_code: 'VOUCHER', rule_code: 'FOO' }]
      co = Checkout.new(pricing_rules)
      co.scan('MUG')
      co.scan('VOUCHER')
      co.scan('TSHIRT')
      co.total.must_equal '32.50€'
    end
  end

  describe 'when scanning a non-existent product' do
    it 'returns the regular value for a VOUCHER, TSHIRT and MUG' do
      co = Checkout.new
      co.scan('MUG')
      co.scan('JEAN')
      co.scan('TSHIRT')
      co.total.must_equal '27.50€'
    end
  end

  describe 'when there are rules and rule_options is empty and needed' do
    it 'returns the regular value for the item' do
      pricing_rules = [{ product_code: 'TSHIRT', rule_code: 'BULK' }]
      @co = Checkout.new(pricing_rules)
      @co.scan('TSHIRT')
      @co.scan('TSHIRT')
      @co.scan('TSHIRT')
      @co.scan('TSHIRT')
      @co.total.must_equal '80.00€'
    end
  end
end
