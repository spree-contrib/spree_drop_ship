//= require spree/frontend
//= require_tree .

$(document).ready(function() {

  $('#supplier_merchant_type').on('change', function(){
    if($(this).val() == 'business') {
      $('#supplier_tax_id').attr('disabled', false);
      $('#supplier_tax_id_field').show();
    } else {
      $('#supplier_tax_id').attr('disabled', true);
      $('#supplier_tax_id_field').hide();
    }
  }).change();

});
