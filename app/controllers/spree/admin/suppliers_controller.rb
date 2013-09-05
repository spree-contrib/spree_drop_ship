class Spree::Admin::SuppliersController < Spree::Admin::ResourceController

  def edit
    @object.address = Spree::Address.default unless @object.address.present?
    respond_with(@object) do |format|
      format.html { render :layout => !request.xhr? }
      format.js   { render :layout => false }
    end
  end

  def new
    @supplier = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  private

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
