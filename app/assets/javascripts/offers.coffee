offersTableReady =->
  return false if $('.offers-table').length == 0
  $('#offers-search').typeahead {
    hint: true
    highlight: true
    minLength: 1
    async: true
  },
    source: (query, sync, async) ->
      $.get '/offers/suggestions', { query: query }, (data) ->
        async data

  $('#offers-search').bind 'typeahead:select', (e, suggestion) ->
    window.location.search = '?query=' + suggestion
    return true

  $('#offers-search').keyup (e) ->
    if e.keyCode == 13
      value = $(e.target).val()
      if value.length > 0
        window.location.search = '?query=' + value
      else
        window.location.search = ''
    return

offersManageReady =->
  return false if $('.offer-form').length == 0
  $('.customers-search').typeahead {
    hint: true
    highlight: true
    minLength: 1
    async: true
  },
    source: (query, sync, async) ->
      $.get '/customers/autocomplete', { query: query }, (data) ->
        async data

    display: (data) ->
      data.text

  $('.customers-search').bind 'typeahead:select', (e, suggestion) ->
    $('#offer_customer_id').val(suggestion.id)
    return true

offersReady = ->
  offersTableReady()
  offersManageReady()
  
$(document).on('turbolinks:load', offersReady)

