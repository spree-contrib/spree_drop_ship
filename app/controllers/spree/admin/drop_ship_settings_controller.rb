class Spree::Admin::DropShipSettingsController < Spree::Admin::BaseController
  def update
    # Workaround for unset checkbox behaviour.
    params[:preferences][:send_supplier_welcome_email] = false if params[:preferences][:send_supplier_welcome_email].blank?
    Spree::DropShipConfig.set(params[:preferences])
    flash[:success] = t('spree.admin.drop_ship_settings.update.success')
    respond_to do |format|
      format.html do
        redirect_to edit_admin_drop_ship_settings_path
      end
    end
  end
end
