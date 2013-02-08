Spree::Admin::ProductsController.class_eval do

  before_filter :get_suppliers, :only => [ :edit, :update ]
  update.before :attach_supplier

  def index
    if spree_current_user.supplier
      @products = Spree::Product.by_supplier(current_user.supplier)
    else
      @products = Spree::Product.all
    end
  end

  private

  def attach_supplier
    if params[:supplier_id].present?
      @supplier = Spree::Supplier.find(params[:supplier_id]) rescue nil
      return unless @supplier
      unless @product.has_supplier? && @product.supplier == @supplier
        @product.supplier_product.destroy if @product.has_supplier?
        @supplier.supplier_products.create(:product_id => @product.id)
      end
    elsif @product.has_supplier?
      @product.supplier_product.destroy
    end
  end

  def get_suppliers
    @supplier_options = Spree::Supplier.order(:name).all.map{ |s| [ s.name, s.id ] }
  end

end
