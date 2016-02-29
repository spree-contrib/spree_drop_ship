Spree::Admin::ProductsController.class_eval do

  belongs_to :supplier

  before_filter :get_suppliers, only: [:edit, :update]
  before_filter :supplier_collection, only: [:index]

  private

  def get_suppliers
    @suppliers = Spree::Supplier.order(:name)
  end

  # Scopes the collection to the Supplier.
  def supplier_collection
    if try_spree_current_user && !try_spree_current_user.admin? && try_spree_current_user.supplier?
      @collection = @collection.joins(:suppliers).where('spree_suppliers.id = ?', try_spree_current_user.supplier_id)
    end
  end

end
