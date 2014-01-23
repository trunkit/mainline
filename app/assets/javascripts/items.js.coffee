# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
SiteBindings.item = {
  favorite: ->
    $('a.favorite').click ->
      $.ajax
        url: $(@).attr("href")
        dataType: "json"
        type: "PUT"
        complete: ->
          true

      false
    true
}
