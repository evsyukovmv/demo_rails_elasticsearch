customersTableReady =->
  return false if $('.customers-table').length == 0
  $('#customers-search').typeahead {
    hint: true
    highlight: true
    minLength: 1
    async: true
  },
    source: (query, sync, async) ->
      $.get '/customers/suggestions', { query: query }, (data) ->
        async data

  $('#customers-search').bind 'typeahead:select', (e, suggestion) ->
    window.location.search = '?query=' + suggestion
    return true

  $('#customers-search').keyup (e) ->
    if e.keyCode == 13
      value = $(e.target).val()
      if value.length > 0
        window.location.search = '?query=' + value
      else
        window.location.search = ''
    return

customersManageReady =->
  return false if $('.customer-form').length == 0
  $('#company-autocomplete').typeahead {
    hint: true
    highlight: true
    minLength: 1
    async: true
  },
    source: (query, sync, async) ->
      $.get '/companies/autocomplete', { query: query }, (data) ->
        async data

    display: (data) ->
      data.text

  $('#company-autocomplete').bind 'typeahead:select', (e, suggestion) ->
    $('#customer_company_id').val(suggestion.id)
    return true

customersReady = ->
  customersTableReady()
  customersManageReady()
  
$(document).on('turbolinks:load', customersReady)

