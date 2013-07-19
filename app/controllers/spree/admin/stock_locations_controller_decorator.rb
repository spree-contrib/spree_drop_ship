Spree::Api::StockLocationsController.class_eval do
  
  before_filter :supplier_transfers, only: [:index]

  private
  
  def supplier_transfers
    params[:q] ||= {}
    params[:q][:supplier_id_eq] = spree_current_user.supplier_id
  end
  
end