class Product

  # Available products
  PRODUCTS_LIST = [
    { product_code: "VOUCHER", price: 5 },
    { product_code: "TSHIRT", price: 20},
    { product_code: "MUG", price: 7.5 }
  ]

  # Helper method to return a product by its code
  def self.find_by_product_code(product_code)
    PRODUCTS_LIST.find{ |pl| pl[:product_code] == product_code }
  end
end
