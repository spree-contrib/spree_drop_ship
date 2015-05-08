Deface::Override.new(
    :virtual_path => 'spree/admin/shared/_main_menu',
    :name => 'add_links_to_admin_menu',
    :insert_after => '.nav-sidebar:last',
    :text => "
    <% if can? :admin, Spree::Supplier %>
      <ul class='nav nav-sidebar'>
        <%= tab :suppliers, label: Spree.t(:suppliers), icon: 'transfer' %>
      </ul>
    <% end %>
")