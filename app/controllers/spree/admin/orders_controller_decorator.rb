Spree::Admin::OrdersController.class_eval do

  def drop_ship_approve
    @order = load_order
    if @order.approve_drop_ship_orders
      flash[:success] = I18n.t('spree.admin.drop_ship_orders.orders_sent')
    else
      flash[:error] = I18n.t('spree.admin.drop_ship_orders.orders_not_sent')
    end
    redirect_to admin_order_path(@order)
  end

end
