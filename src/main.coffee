{BrowserWindow, app} = require 'electron'

# the main window
window = null

app.on 'ready', ->
    # create the main window
    window = new BrowserWindow {width: 900, height: 700}
    window.loadURL "file://#{__dirname}/../ressources/index.html"
    window.on 'closed', ->
        app.quit()
