class Spree::SuppliersController < Spree::StoreController

  before_filter :check_authentication

  def create
    @supplier = Spree::Supplier.new(params[:supplier])
    if @supplier.save
      flash[:success] = t('spree.suppliers.create.success')
      redirect_to spree.root_path
    else
      @supplier.build_address country_id: Spree::Address.default.country_id if @supplier.address.nil?
      render :new
    end
  end

  def edit
    @supplier = Spree::Supplier.find(params[:id])
    authorize! :edit, @supplier
  end

  def new
    @supplier = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  def update
    @supplier = Spree::Supplier.find(params[:id])
    authorize! :update, @supplier
    if @supplier.update_attributes(params[:supplier])
      flash[:success] = t('spree.suppliers.update.success')
      redirect_to spree.account_path(@supplier.user)
    else
      render :edit
    end
  end

  private

  # Check user is logged in.
  def check_authentication
    return if spree_current_user
    flash[:error] = t(:must_be_logged_in)
    redirect_to spree_login_path
  end

end
