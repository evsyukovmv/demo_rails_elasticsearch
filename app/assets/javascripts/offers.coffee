# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
  $('.typeahead').typeahead {
    hint: true
    highlight: true
    minLength: 1,
    async: true
  },
    source: (query, sync, async) ->
      $.get '/offers/autocomplete', { query: query }, (data) ->
        async data

  $('.typeahead').bind 'typeahead:select', (e, suggestion) ->
    search = window.location.search
    if search.length > 0
      if search.search('query')
        window.location.search = search.replace(/query=[^&]+/, 'query=' + suggestion)
      else
        window.location.search = search + '&query=' + suggestion
    else
      window.location.search = '?query=' + suggestion
    return
