if defined?(Ckeditor::PicturesController)
  Ckeditor::PicturesController.class_eval do
    load_and_authorize_resource class: 'Ckeditor::Picture'
    after_action :set_supplier, only: [:create]

    def index; end

    private

    def set_supplier
      if spree_current_user.supplier? && @picture
        @picture.supplier = spree_current_user.supplier
        @picture.save
      end
    end
  end
end
