if defined?(Ckeditor::AttachmentFilesController)
  Ckeditor::AttachmentFilesController.class_eval do
    load_and_authorize_resource :class => 'Ckeditor::AttachmentFile'
    after_filter :set_supplier, only: [:create]

    def index
    end

    private
    def set_supplier
      if spree_current_user.supplier? and @attachment
        @attachment.supplier = spree_current_user.supplier
        @attachment.save
      end
    end
  end
end
