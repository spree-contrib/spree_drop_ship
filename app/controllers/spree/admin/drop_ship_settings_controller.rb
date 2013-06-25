class Spree::Admin::DropShipSettingsController < Spree::Admin::BaseController

  def edit
    @config = Spree::DropShipConfiguration.new
  end

  def update
    config = Spree::DropShipConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    flash[:success] = Spree.t('spree.admin.drop_ship_settings.update.success')
    redirect_to spree.edit_admin_drop_ship_settings_path
  end

end
