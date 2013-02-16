module Spree
  class DropShipOrdersController < Spree::StoreController

    load_and_authorize_resource class: 'Spree::DropShipOrder'

    def show
      redirect_to edit_drop_ship_order_path(@drop_ship_order) unless @drop_ship_order.complete?
    end

    # TODO: sloppy state transition needs to be refactored.
    def edit
      if @drop_ship_order.sent?
        flash[:notice] = I18n.t('supplier_orders.flash.sent')
      elsif @drop_ship_order.confirmed?
        if @drop_ship_order.errors.empty?
          flash[:notice] = I18n.t('supplier_orders.flash.confirmed')
        end
      end
      redirect_to @drop_ship_order if @drop_ship_order.complete?
    end

    # TODO: sloppy state transition needs to be refactored.
    def update
      if @drop_ship_order.sent?
        success = @drop_ship_order.confirm
        url = edit_drop_ship_order_path(@drop_ship_order)
      elsif @drop_ship_order.confirmed?
        success = @drop_ship_order.update_attributes(params[:drop_ship_order]) && @drop_ship_order.ship
        url = drop_ship_order_path(@drop_ship_order)
        flash[:notice] = I18n.t('supplier_orders.flash.shipped') if success
      end

      if success
        redirect_to url
      else
        flash[:error] = I18n.t("supplier_orders.flash.#{@drop_ship_order.confirmed? ? 'confirmation_failure' : 'finalize_failure'}")
        render :edit
      end

    end

  end
end
