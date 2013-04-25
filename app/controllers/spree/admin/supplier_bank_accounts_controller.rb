class Spree::Admin::SupplierBankAccountsController < Spree::Admin::ResourceController

  before_filter :load_supplier
  create.before :set_supplier

  # Overridding the flash[:success]
  def create
    invoke_callbacks(:create, :before)
    @object.attributes = params[object_name]
    if @object.save
      invoke_callbacks(:create, :after)
      flash[:success] = I18n.t(:verify_bank_account)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
      end
    else
      invoke_callbacks(:create, :fails)
      respond_with(@object)
    end
  end

  def new
    @bank_account = @supplier.bank_accounts.build
  end

  # Overridding the flash[:success]
  def update
    invoke_callbacks(:update, :before)
    if @object.update_attributes(params[object_name])
      invoke_callbacks(:update, :after)
      flash[:success] = I18n.t(:verified_bank_account)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
      end
    else
      invoke_callbacks(:update, :fails)
      respond_with(@object)
    end
   end

  private

    def load_supplier
      @supplier = Spree::Supplier.find(params[:supplier_id])
    end

    def location_after_save
      spree.edit_admin_supplier_path(@supplier)
    end

    def set_supplier
      @object.supplier = @supplier
    end

end
