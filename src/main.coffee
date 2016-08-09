{BrowserWindow, app, ipcMain, dialog} = require 'electron'
fs = require 'fs'
# the main window
window = null

openFile = null


app.on 'ready', ->
    # create the main window
    window = new BrowserWindow {width: 900, height: 700}
    window.loadURL "file://#{__dirname}/../ressources/index.html"
    window.on 'close', (e) ->
        window.webContents.send 'closing'
        e.preventDefault()

    # load menus
    require('./menu')()

ipcMain.on 'print-to-pdf', (event, path) ->
    options =
        marginType: 1
        pageSize:'A4'
        printBackground: yes

    window.webContents.printToPDF options, (error, data) ->
        throw error if error?
        fs.writeFile path, data, (error) ->
            throw error if error?
            window.webContents.send 'pdf-saved'
