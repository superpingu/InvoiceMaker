$ = require 'jquery'

selectedType = 'quotation'

$ ->
    changeType = (btn, type) ->
        $('body').css 'background-image', "url(images/#{type}.svg)"
        $('.selected-btn').removeClass 'selected-btn'
        $(btn).addClass 'selected-btn'
        selectedType = type
    $('.invoice-btn').click -> changeType this, 'invoice'
    $('.quotation-btn').click -> changeType this, 'quotation'

    $('body').mousemove (event) ->
        x = event.pageX*100/$(document).width()
        y = event.pageY*100/$(document).width()
        console.log "top: #{y}, left: #{x}"
    $('.price').keyup ->
        $('.top-price').html($(this).val())
