$ = require 'jquery'
jsonfile = require 'jsonfile'
ipc = require('electron').ipcRenderer
app = require('electron').remote.app
dialog = require('electron').remote.dialog
os = require 'os'
path = require 'path'
shell = require 'shelljs'

selectedType = 'quotation'
reloading = false
modified = false
saveCallback = null

now = new Date()
month = now.getMonth() + 1
day = now.getDate()
month = '0' + month if month < 10
day = '0' + day if day < 10

getNumber = (year) ->
    counters = jsonfile.readFileSync __dirname+'/counters.json'
    number = counters[year]?[selectedType] ? 1
    number = '0' + number if number < 10
    return number

changeType = (btn, type) ->
    $('.bg').attr 'src', "images/#{type}.svg"
    $('.selected-btn').removeClass 'selected-btn'
    $(btn).addClass 'selected-btn'
    selectedType = type
    $('.number').val '' + now.getFullYear() + month + getNumber(now.getFullYear())

getContent = ->
    content = {}
    $('input').each ->
        name = $(this).attr('class').split(' ').join('_')
        content[name] = $(this).val()
    content.adress = $('.adress').val()
    content.type = selectedType
    return content
setContent = (content) ->
    changeType ".#{content.type}-btn", content.type
    delete content.type

    for field, value of content
        $('.'+field.split('_').join('.')).val(value)
    $('.price').keyup()

showControls = (show) ->
    $('input').blur().css 'border-color', if show then 'rgb(159, 155, 155)' else 'transparent'
    $('textarea').blur().css 'border-color', if show then 'rgb(159, 155, 155)' else 'transparent'
    $('.invoice-select').show() if show
    $('.invoice-select').hide() if not show

open = (filepath) ->
    pdfDir = filepath.split '/'
    pdfName = pdfDir.pop().split('.')[0]
    content = jsonfile.readFileSync '/' + pdfDir.join('/') + '/.' + pdfName + '.json'
    setContent content
    modified = false

save = (callback) ->
    showControls no

    content = getContent()
    year = content.date.split('.')[2]
    pdfPath = path.join os.homedir(), "Factures/#{year}/"
    pdfName = (if selectedType is 'invoice' then 'Facture-' else 'Devis-') + content.number
    shell.mkdir '-p', pdfPath

    ipc.send 'print-to-pdf', pdfPath + pdfName + '.pdf'
    jsonfile.writeFile pdfPath + '.' + pdfName + '.json', content

    counters = jsonfile.readFileSync __dirname+'/counters.json'
    lastNumber = (counters[year]?[selectedType] ? 1)
    currentNumber = parseInt content.number.substring(6)

    if currentNumber == lastNumber
        counters[year] = {} unless counters[year]?
        counters[year][selectedType]++
        jsonfile.writeFile __dirname+'/counters.json', counters

    modified = false
    saveCallback = callback

print = ->
    showControls no
    window.print()
    showControls yes

askToSave = (action) ->
    options =
      type: 'info'
      title: 'Enregistrement'
      message: 'Souhaitez-vous enregistrer le document ?'
      buttons: ['Enregistrer', 'Ne pas enregistrer']
    dialog.showMessageBox options, (index) ->
      save action if index == 0
      action() if index != 0

ipc.on 'closing', ->
    app.exit(0) if not modified
    askToSave -> app.exit(0)
ipc.on 'save', -> save()
ipc.on 'print', -> print()
ipc.on 'open', (event, filepath) -> open filepath[0]
ipc.on 'pdf-saved', ->
    saveCallback?()
    showControls yes

$ ->
    $('.invoice-btn').click -> changeType this, 'invoice'
    $('.quotation-btn').click -> changeType this, 'quotation'

    $('.price').keyup ->
        $('.top-price').html($(this).val())

    $('.date').val "#{day}.#{month}.#{now.getFullYear()}"
    $('.number').val '' + now.getFullYear() + month + getNumber(now.getFullYear())

    $('input').change ->
        modified = true

    window.onbeforeunload = (e) ->
        return if reloading or not modified
        askToSave ->
            reloading = true
            location.reload()
        e.returnValue = false
