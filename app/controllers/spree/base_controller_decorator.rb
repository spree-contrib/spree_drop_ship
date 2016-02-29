Spree::BaseController.class_eval do

  # prepend_before_filter :redirect_supplier

  before_action :authorize_supplier

  # private

  # def redirect_supplier
  #   if ['/admin', '/admin/authorization_failure'].include?(request.path) && try_spree_current_user.try(:supplier)
  #     redirect_to '/admin/shipments' and return false
  #   end
  # end
  protected

  def authorize_supplier
    if respond_to?(:model_class, true) && model_class
      record = model_class
    else
      record = controller_name.to_sym
    end
    authorize! :supplier, record
    authorize! action, record
  end

end
