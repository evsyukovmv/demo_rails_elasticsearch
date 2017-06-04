companiesTableReady =->
  return false if $('.companies-table').length == 0
  $('#companies-search').typeahead {
    hint: true
    highlight: true
    minLength: 1
    async: true
  },
    source: (query, sync, async) ->
      $.get '/companies/suggestions', { query: query }, (data) ->
        async data

  $('#companies-search').bind 'typeahead:select', (e, suggestion) ->
    window.location.search = '?query=' + suggestion
    return true

  $('#companies-search').keyup (e) ->
    if e.keyCode == 13
      value = $(e.target).val()
      if value.length > 0
        window.location.search = '?query=' + value
      else
        window.location.search = ''
    return

companiesManageReady =->
  return false if $('.company-form').length == 0

companiesReady = ->
  companiesTableReady()
  companiesManageReady()
  
$(document).on('turbolinks:load', companiesReady)

