# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#offers-search').typeahead {
    hint: true
    highlight: true
    minLength: 1
    async: true
  },
    source: (query, sync, async) ->
      $.get '/offers/autocomplete', { query: query }, (data) ->
        async data

  $('.offers-search').bind 'typeahead:select', (e, suggestion) ->
    window.location.search = '?query=' + suggestion
    return true

  $('.offers-search').keyup (e) ->
    if e.keyCode == 13
      value = $(e.target).val()
      if value.length > 0
        window.location.search = '?query=' + value
      else
        window.location.search = ''
    return

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

$(document).on('turbolinks:load', ready)

