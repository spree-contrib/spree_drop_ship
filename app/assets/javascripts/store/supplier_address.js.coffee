Spree.ready ($) ->
  if ($ '#new_supplier').is('*')
    ($ '#new_supplier').validate()

    getCountryId = (region) ->
      $('p#' + region + 'country select').val()

    updateState = (region) ->
      countryId = getCountryId(region)
      if countryId?
        unless Spree.Checkout[countryId]?
          $.get Spree.routes.states_search + "/?country_id=#{countryId}", (data) ->
            Spree.Checkout[countryId] =
              states: data.states
              states_required: data.states_required
            fillStates(Spree.Checkout[countryId], region)
        else
          fillStates(Spree.Checkout[countryId], region)

    fillStates = (data, region) ->
      statesRequired = data.states_required
      states = data.states

      statePara = ($ 'p#' + region + 'state')
      stateSelect = statePara.find('select')
      stateInput = statePara.find('input')
      stateSpanRequired = statePara.find('state-required')
      if states.length > 0
        selected = parseInt stateSelect.val()
        stateSelect.html ''
        statesWithBlank = [{ name: '', id: ''}].concat(states)
        $.each statesWithBlank, (idx, state) ->
          opt = ($ document.createElement('option')).attr('value', state.id).html(state.name)
          opt.prop 'selected', true if selected is state.id
          stateSelect.append opt

        stateSelect.prop('disabled', false).show()
        stateInput.hide().prop 'disabled', true
        statePara.show()
        stateSpanRequired.show()
      else
        stateSelect.hide().prop 'disabled', true
        stateInput.show()
        if statesRequired
          stateSpanRequired.show()
        else
          stateInput.val ''
          stateSpanRequired.hide()
        statePara.toggle(!!statesRequired)
        stateInput.prop('disabled', !statesRequired)

    ($ 'p#ccountry select').change ->
      updateState 'c'

    updateState 'c'
