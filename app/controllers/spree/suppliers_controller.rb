class Spree::SuppliersController < Spree::StoreController

  before_filter :check_if_supplier, only: [:create, :new]
  ssl_required

  def create
    authorize! :create, Spree::Supplier
    @supplier = Spree::Supplier.new(params[:supplier])
    if @supplier.save
      flash[:success] = Spree.t('supplier_registration.create.success')
      redirect_to spree.root_path
    else
      @supplier.address = Spree::Address.default if @supplier.address.nil?
      render :new
    end
  end

  def new
    authorize! :create, Spree::Supplier
    @supplier = Spree::Supplier.new
    @supplier.address = Spree::Address.default
  end

  private

  def check_if_supplier
    if spree_current_user and spree_current_user.supplier?
      flash[:error] = Spree.t('supplier_registration.already_signed_up')
      redirect_to spree.account_path and return
    end
  end

end
