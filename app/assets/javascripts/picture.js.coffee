# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->
  $('#download-as-zip').css(display: 'none')
  .click ->
    $("input.for-zip-cb:checked").map(-> $(this).val())
    picture_list = $("input.for-zip-cb:checked").map(-> $(this).val()).toArray().join("+")
    alert "/pictures/tar/#{picture_list}/photos.tar"

    $(this).attr(href: "/pictures/tar/#{picture_list}/photos.tar")
    return true

  $("input.for-zip-cb").change ->
    if $("input.for-zip-cb:checked").length > 0
      $('#download-as-zip').css display: 'block'
    else
      $('#download-as-zip').css display: 'none'

  #$("#upload-zone").each ->
  #  $("#new_picture").fileupload url: "pictures/new"
  #  $("#new_picture").fileupload 'option', 'redirect', /\/[^\/]*$/, '/pictures'
