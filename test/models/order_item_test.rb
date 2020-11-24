require "test_helper"

describe OrderItem do
  let(:order_item) {
    order_items(:order_item1)
  }

  describe "validations" do
    it "is valid when all fields are present" do
      expect(order_item.valid?).must_equal true
    end

    it "is not valid without a product" do
      order_item.product = nil

      expect(order_item.valid?).must_equal false
      expect(order_item.errors.messages).must_include :product
      expect(order_item.errors.messages[:product]).must_include "can't be blank"
    end

    it "is not valid without an order" do
      order_item.order = nil

      expect(order_item.valid?).must_equal false
      expect(order_item.errors.messages).must_include :order
      expect(order_item.errors.messages[:order]).must_include "can't be blank"
    end

    it "is not valid without a quantity" do
      order_item.quantity = nil

      expect(order_item.valid?).must_equal false
      expect(order_item.errors.messages).must_include :quantity
      expect(order_item.errors.messages[:quantity]).must_include "can't be blank"
    end

    it "order item quantity can't be greater than inventory" do
      product_inventory = order_item.product.quantity
      order_item.quantity = product_inventory + 10

      expect(order_item.valid?).must_equal false
      expect(order_item.errors.messages).must_include :quantity
    end

    it "is not valid if quantity is 0" do
      order_item.quantity = 0

      expect(order_item.valid?).must_equal false

      expect(order_item.errors.messages).must_include :quantity
      expect(order_item.errors.messages[:quantity]).must_include "must be greater than 0"
    end

    it "is not valid if quantity is less than 1" do
      order_item.quantity = -1

      expect(order_item.valid?).must_equal false

      expect(order_item.errors.messages).must_include :quantity
      expect(order_item.errors.messages[:quantity]).must_include "must be greater than 0"
    end
  end


  describe "relations" do
    it "it can set product through 'product'" do
      product = products(:product1)
      order_item.product = product

      expect(order_item.product_id).must_equal product.id
    end

    it "it can set product through 'product_id'" do
      product = products(:product1)
      order_item.product_id = product.id

      expect(order_item.product).must_equal product
    end

    it "it can set order through 'order'" do
      order = orders(:order7)
      order_item.order_id = order.id

      expect(order_item.order).must_equal order
    end

    it "it can set order through 'order'" do
      order = orders(:order7)
      order_item.order = order

      expect(order_item.order_id).must_equal order.id
    end

    it "can set order through 'user'" do
      user = users(:user1)
      order_item.user = user

      expect(order_item.user).must_equal user
    end
  end


  describe "custom model methods" do
    describe "name" do
      it "returns name of product" do
        product_name = products(:product7).name

        expect(order_item.name).must_equal product_name
      end
    end

    describe "subtotal" do
      it "returns the subtotal of order items" do
        quantity = order_item.quantity
        product_price = order_item.product.price

        expected_subtotal = quantity * product_price

        expect(order_item.subtotal).must_equal expected_subtotal
      end
    end

    describe "mark_shipped" do
      it "sets shipped status to true" do
        order_item.shipped = false

        order_item.mark_shipped

        expect(order_item.shipped).must_equal true
      end

      it "sets shipped status to true even if already true" do
        order_item.shipped = true

        order_item.mark_shipped

        expect(order_item.shipped).must_equal true
      end
    end
  end
end
