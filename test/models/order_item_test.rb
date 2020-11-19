require "test_helper"

describe OrderItem do
  let(:order_item) {
    order_items(:order_item1)
  }

  describe "validations" do
    it "order item quantity can't be greater than inventory" do
      product_inventory = order_item.product.quantity
      order_item.quantity = product_inventory + 10

      expect(order_item.valid?).must_equal false
      expect(order_item.errors.messages).must_include :quantity
    end
  end

  describe "custom model methods" do
    describe "subtotal" do
      it "returns the subtotal of order items" do
        quantity = order_item.quantity
        product_price = order_item.product.price

        expected_subtotal = quantity * product_price

        expect(order_item.subtotal).must_equal expected_subtotal
      end
    end

    describe "sell" do
      it "removes order item quantity from product inventory" do
        quantity = order_item.quantity
        product_inventory = order_item.product.quantity

        expected_inventory_after = product_inventory - quantity

        expect(order_item.sell(quantity)).must_equal expected_inventory_after
      end

      it "does not change inventory if order item quantity is greater than inventory" do
        product_inventory = order_item.product.quantity
        order_item.quantity = product_inventory + 10

        order_item.sell(order_item.quantity)

        expect(order_item.product.quantity).must_equal product_inventory
      end
    end
  end
end
