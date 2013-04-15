module Spree
  module Api
    ShipmentsController.class_eval do

      # TODO figure out exactly why record is being loaded as readonly so we don't have to override method with readonly: false here.
      def update
        @shipment = @order.shipments.find_by_number!(params[:id], readonly: false)
        authorize! :update, @shipment

        unlock = params[:shipment].delete(:unlock)

        if unlock == 'yes'
          @shipment.adjustment.open
        end

        @shipment.update_attributes(params[:shipment])

        if unlock == 'yes'
          @shipment.adjustment.close
        end

        @shipment.reload
        respond_with(@shipment, :default_template => :show)
      end

      private

      def find_order
        if params[:order_id]
          @order = Spree::Order.find_by_number!(params[:order_id])
        elsif params[:drop_ship_order_id]
          @order = Spree::DropShipOrder.find(params[:drop_ship_order_id])
        end
        authorize! :read, @order
      end

      # TODO figure out exactly why record is being loaded as readonly so we don't have to override method with readonly: false here.
      def find_and_update_shipment
        @shipment = @order.shipments.find_by_number(params[:id], readonly: false)
        @shipment.update_attributes(params[:shipment]) if params[:shipment]
        @shipment.reload
      end

    end
  end
end
