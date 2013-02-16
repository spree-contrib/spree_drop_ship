class Spree::Admin::DropShipOrdersController < Spree::Admin::ResourceController

  def show
    @drop_ship_order = load_resource
    @supplier = @drop_ship_order.supplier
    @address = @drop_ship_order.order.ship_address
  end

  def deliver
    @drop_ship_order = load_resource
    if @drop_ship_order.deliver
      flash[:notice] = t('spree.admin.drop_ship_orders.deliver.success', number: @drop_ship_order.id)
    else
      flash[:error] = t('spree.admin.drop_ship_orders.deliver.error', number: @drop_ship_order.id)
    end
    redirect_to admin_drop_ship_order_path(@drop_ship_order)
  end

  private

    def collection
      params[:q] ||= {}
      params[:q][:meta_sort] ||= "id.desc"
      scope = if params[:supplier_id] && @supplier = Spree::Supplier.find(params[:supplier_id])
        @supplier.orders
      elsif params[:order_id] && @order = Spree::Order.find_by_number(params[:order_id])
        @order.drop_ship_orders
      else
        Spree::DropShipOrder.scoped
      end
      @search = scope.includes(:supplier).search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

end
