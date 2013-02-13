class Spree::Admin::DropShipOrdersController < Spree::Admin::ResourceController

  def show
    @dso = load_resource
    @supplier = @dso.supplier
    @address = @dso.order.ship_address
  end

  def deliver
    @dso = load_resource
    if @dso.deliver
      flash[:notice] = t('spree.admin.drop_ship_orders.deliver.success', number: @dso.id)
    else
      flash[:error] = t('spree.admin.drop_ship_orders.deliver.error', number: @dso.id)
    end
    redirect_to admin_drop_ship_order_path(@dso)
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
