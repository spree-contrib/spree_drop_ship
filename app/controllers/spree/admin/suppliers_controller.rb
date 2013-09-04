class Spree::Admin::SuppliersController < Spree::Admin::ResourceController

  update.before :build_address

  def new
    @supplier = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  private

    def build_address
      @supplier.address = Spree::Address.default unless @supplier.address.present?
    end

    def collection
      params[:q] ||= {}
      params[:q][:meta_sort] ||= "name.asc"
      @search = Spree::Supplier.search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

    def location_after_save
      spree.edit_admin_supplier_path(@supplier)
    end

end
