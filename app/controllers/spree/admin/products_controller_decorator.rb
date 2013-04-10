Spree::Admin::ProductsController.class_eval do

  before_filter :get_suppliers, only: [:edit, :update]
  before_filter :supplier_collection, only: [:index]

  private

  def get_suppliers
    @suppliers = Spree::Supplier.order(:name)
  end

  # Scopes the collection to the Supplier.
  def supplier_collection
    if spree_current_user.supplier and !spree_current_user.admin?
      @collection = @collection.joins(:supplier).where('spree_suppliers.id = ?', spree_current_user.supplier_id)
    end
  end

end
