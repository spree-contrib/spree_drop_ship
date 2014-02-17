//= require spree/backend
// Shipments AJAX API

$(document).ready(function() {

  //handle ship click
  $('[data-hook=admin_drop_ship_order_form] a.ship').click(function(){
    var link = $(this);
    var shipment_number = link.data('shipment-number');
    var url = Spree.url("/api/drop_ship_orders/" + order_number + "/shipments/" + shipment_number + "/ship.json");

    $.ajax({
      type: "PUT",
      url: url
    }).done(function( msg ) {
      // TODO update this and spree core to update the dom not reload the page..
      window.location.reload();
    }).error(function( msg ) {
      console.log(msg);
    });
  });

  //handle shipping method save
  $('[data-hook=admin_drop_ship_order_form] a.save-method').click(function(){
    var link = $(this);
    var shipment_number = link.data('shipment-number');
    var selected_shipping_rate_id = link.parents('tbody').find("select#selected_shipping_rate_id[data-shipment-number='" + shipment_number + "']").val();
    var unlock = link.parents('tbody').find("input[name='open_adjustment'][data-shipment-number='" + shipment_number + "']:checked").val();
    var url = Spree.url("/api/drop_ship_orders/" + order_number + "/shipments/" + shipment_number + ".json");

    $.ajax({
      type: "PUT",
      url: url,
      data: { shipment: { selected_shipping_rate_id: selected_shipping_rate_id, unlock: unlock  } }
    }).done(function( msg ) {
      window.location.reload();
    }).error(function( msg ) {
      console.log(msg);
    });
  });

  //handle tracking save
  $('[data-hook=admin_drop_ship_order_form] a.save-tracking').click(function(){
    var link = $(this);
    var shipment_number = link.data('shipment-number');
    var tracking = link.parents('tbody').find('input#tracking').val();
    var url = Spree.url("/api/drop_ship_orders/" + order_number + "/shipments/" + shipment_number + ".json");

    $.ajax({
      type: "PUT",
      url: url,
      data: { shipment: { tracking: tracking } }
    }).done(function( msg ) {
      window.location.reload();
    }).error(function( msg ) {
      console.log(msg);
    });
  });

});
