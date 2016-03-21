Spree::BaseController.class_eval do

  before_action :authorize_supplier

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
