module Spree
  module Admin
    class ShipmentsController < Spree::Admin::ResourceController
      def index
        params[:q] ||= {}
        # params[:q][:completed_at_null] ||= '1'
        # @show_only_incomplete = params[:q][:completed_at_null].present?
        # params[:q][:s] ||= @show_only_incomplete ? 'created_at desc' : 'completed_at desc'

        # As date params are deleted if @show_only_incomplete, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]

        if params[:q][:created_at_gt].present?
          params[:q][:created_at_gt] = begin
                                         Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
                                       rescue
                                         ''
                                       end
        end

        if params[:q][:created_at_lt].present?
          params[:q][:created_at_lt] = begin
                                         Time.zone.parse(params[:q][:created_at_lt]).end_of_day
                                       rescue
                                         ''
                                       end
        end

        @search = Spree::Shipment.accessible_by(current_ability, :index).ransack(params[:q])
        @shipments = @search.result
                            .page(params[:page])
                            .per(per_page)

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
      end

      private

      def per_page
        params[:per_page] || admin_orders_per_page || orders_per_page
      end

      def admin_orders_per_page
        Spree::Config[:admin_orders_per_page] if Spree::Config.has_preference?(:admin_orders_per_page)
      end

      def orders_per_page
        Spree::Config[:orders_per_page] if Spree::Config.has_preference?(:orders_per_page)
      end

      def find_resource
        if parent_data.present?
          parent.send(controller_name).find_by!(number: params[:id])
        else
          model_class.find_by!(number: params[:id])
        end
      end
    end
  end
end
