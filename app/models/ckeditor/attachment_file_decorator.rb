if defined?(Ckeditor::AttachmentFile)
  Ckeditor::AttachmentFile.class_eval do
    belongs_to :supplier, class_name: 'Spree::Supplier'
  end
end
