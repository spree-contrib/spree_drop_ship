class Spree::SuppliersController < Spree::StoreController

  before_filter :check_if_supplier, only: [:create, :new]
  ssl_required

  def create
    @supplier = Spree::Supplier.new(params[:supplier])
    authorize! :create, @supplier
    if @supplier.save
      flash[:success] = I18n.t('spree.suppliers.create.success')
      redirect_to spree.root_path
    else
      @supplier.build_address country_id: Spree::Address.default.country_id if @supplier.address.nil?
      render :new
    end
  end

  def new
    @supplier = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
    authorize! :new, @supplier
  end

  private

  def check_if_supplier
    if spree_current_user and spree_current_user.supplier?
      flash[:error] = I18n.t('spree.suppliers.already_signed_up')
      redirect_to spree.account_path and return
    end
  end

end
