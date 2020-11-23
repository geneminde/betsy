require "test_helper"

describe Category do
  describe "initialize" do
    let(:category) {
      Category.new(name: "Great Category")
    }
    it 'can be initialized' do

      expect(category.valid?).must_equal true
    end

    it 'will have the required fields' do
      category.save

      expect(category).must_respond_to :name
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      new_category = Category.new
      expect(new_category.valid?).must_equal false
    end
  end

  describe 'relations' do
    it 'can have many products' do
      category = categories(:category1)
      products = category.products
      products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it 'can add a new product to products' do
      product = products(:product10)
      product_id = product.id
      category = categories(:category1)
      category.products << product

      expect(category.products.find_by(id: product_id)).must_equal product
    end
  end

  describe 'active_products' do
    it 'returns a collection of products that are active' do
      category = categories(:category1)
      actives = category.active_products

      expect(actives.count).must_equal 3
      actives.each do |product|
        expect(product.is_retired?).must_equal false
      end
    end
  end
end
