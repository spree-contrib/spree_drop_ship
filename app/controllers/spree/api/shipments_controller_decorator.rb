module Spree
  module Api
    ShipmentsController.class_eval do

      private

      def find_order
        if params[:order_id]
          @order = Spree::Order.find_by_number!(params[:order_id])
        elsif params[:drop_ship_order_id]
          @order = Spree::DropShipOrder.find(params[:drop_ship_order_id])
        end
        authorize! :read, @order
      end

      def find_and_update_shipment
        @shipment = @order.shipments.find_by_number(params[:id], readonly: false)
        @shipment.update_attributes(params[:shipment]) if params[:shipment]
        @shipment.reload
      end

    end
  end
end
