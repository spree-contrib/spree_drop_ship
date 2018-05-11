class Spree::Admin::SuppliersController < Spree::Admin::ResourceController
  def edit
    @object.address = Spree::Address.default if @object.address.blank?
    respond_with(@object) do |format|
      format.html { render layout: !request.xhr? }
      format.js   { render layout: false }
    end
  end

  def new
    @object = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  private

  def collection
    params[:q] ||= {}
    params[:q][:meta_sort] ||= 'name.asc'
    @search = Spree::Supplier.search(params[:q])
    @collection = @search.result.page(params[:page]).per(per_page)
  end

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
    Spree::Supplier.friendly.find(params[:id])
  end

  def location_after_save
    spree.edit_admin_supplier_path(@object)
  end
end
