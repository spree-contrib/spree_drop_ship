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

    end
  end
end
