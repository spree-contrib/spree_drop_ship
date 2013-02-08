$ ->
  if ($ '#supplier-address').is('*')
    ($ '#supplier-address').validate()

    country_from_region = (region) ->
      ($ 'p#' + region + 'country' + ' span#' + region + 'country-selection :only-child').val()

    get_states = (region) ->
      state_mapper[country_from_region(region)]

    get_states_required = (region) ->
      states_required_mapper[country_from_region(region)]

    update_state = (region) ->
      states = get_states(region)
      states_required  = get_states_required(region)

      state_para = ($ 'p#' + region + 'state')
      state_select = state_para.find('select')
      state_input = state_para.find('input')
      state_span_required = state_para.find('state-required')
      if states
        selected = parseInt state_select.val()
        state_select.html ''
        states_with_blank = [ [ '', '' ] ].concat(states)
        $.each states_with_blank, (pos, id_nm) ->
          opt = ($ document.createElement('option')).attr('value', id_nm[0]).html(id_nm[1])
          opt.prop 'selected', true if selected is id_nm[0]
          state_select.append opt

        state_select.prop('disabled', false).show()
        state_input.hide().prop 'disabled', true
        state_span_required.show()
      else
        state_select.hide().prop 'disabled', true
        state_input.show()
        if states_required
          state_span_required.show()
        else
          state_input.val ''
          state_span_required.hide()
        state_para.toggle(!!states_required)
        state_input.prop('disabled', !states_required)

    ($ 'p#ccountry select').change ->
      update_state 'c'

    update_state 'c'
