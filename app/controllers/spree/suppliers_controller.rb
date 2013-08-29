class Spree::SuppliersController < Spree::StoreController

  before_filter :check_if_supplier, only: [:create, :new]
  ssl_required

  def create
    authorize! :create, Spree::Supplier

    # Dont sign in as the newly created user if users already signed in.
    unless spree_current_user
      # Find or create user for email.
      unless @user = Spree.user_class.find_by_email(params[:supplier][:email])
        @user = Spree.user_class.new(email: params[:supplier][:email], password: params[:supplier].delete(:password), password_confirmation: params[:supplier].delete(:password_confirmation))
        @user.save!
        session[:spree_user_signup] = true
      end
      sign_in(Spree.user_class.to_s.underscore.gsub('/', '_').to_sym, @user)
      associate_user
    end

    # Now create supplier.
    @supplier = Spree::Supplier.new(params[:supplier])
    @supplier.email = spree_current_user.email if spree_current_user

    if @supplier.save
      flash[:success] = Spree.t('supplier_registration.create.success')
      redirect_to spree.account_path
    else
      clean_up_passwords(@user) if @user
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
