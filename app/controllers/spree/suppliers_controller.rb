class Spree::SuppliersController < Spree::StoreController

  before_filter :check_authentication

  def new
    @supplier = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

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

  private

  # Check user is logged in.
  def check_authentication
    return if spree_current_user
    flash[:error] = t(:must_be_logged_in)
    redirect_to spree_login_path
  end

end
