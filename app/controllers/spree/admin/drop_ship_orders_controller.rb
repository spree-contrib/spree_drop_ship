module Spree
  module Admin
    class DropShipOrdersController < Spree::Admin::ResourceController

      def confirm
        @order = DropShipOrder.accessible_by(current_ability, :update).find(params[:id])
        if @order.confirm!
          flash[:notice] = I18n.t('spree.admin.drop_ship_orders.confirm.success', number: @order.id)
        end
        redirect_to spree.edit_admin_drop_ship_order_path(@order)
      end

      def deliver
        @order = DropShipOrder.accessible_by(current_ability, :update).find(params[:id])
        if @order.deliver!
          flash[:notice] = I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order.id)
        end
        redirect_to spree.edit_admin_drop_ship_order_path(@order)
      end

      def edit
        @order = DropShipOrder.accessible_by(current_ability, :edit).find(params[:id])
      end

      def index
        params[:q] ||= {}
        params[:q][:completed_at_null] ||= '1'
        @show_only_incomplete = params[:q][:completed_at_null].present?
        params[:q][:s] ||= @show_only_incomplete ? 'created_at desc' : 'completed_at desc'

        # As date params are deleted if @show_only_incomplete, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]

        params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

        if !params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
        end

        if !params[:q][:created_at_lt].blank?
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
        end

        @search = DropShipOrder.accessible_by(current_ability, :index).ransack(params[:q])
        @orders = @search.result.
          page(params[:page]).
          per(params[:per_page] || Spree::Config[:orders_per_page])

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
      end

    end
  end
end
