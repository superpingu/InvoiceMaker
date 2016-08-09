{Menu, ipcMain} = require 'electron'

template = [
  {
    label: 'Fichier',
    submenu: [
      {
        label: "Nouveau",
        accelerator: 'CmdOrCtrl+N',
        click: (item, focusedWindow) ->
            focusedWindow.reload() if focusedWindow
      },
      {
        label: "Ouvrir",
        accelerator: 'CmdOrCtrl+O',
        click: (item, focusedWindow) ->

      },
      {
        label: 'Enregistrer',
        accelerator: 'CmdOrCtrl+S',
        click: (item, focusedWindow) ->
            focusedWindow.webContents.send 'save'
      },
      {
        label: "Imprimer",
        accelerator: 'CmdOrCtrl+P',
        click: (item, focusedWindow) ->
            focusedWindow.webContents.send 'print'
      }
    ]
  },
  {
    label: 'Édition',
    submenu: [
      {
        label: "Annuler",
        role: 'undo'
      },
      {
        label: "Rétablir",
        role: 'redo'
      },
      {
        type: 'separator'
      },
      {
        label: "Couper",
        role: 'cut'
      },
      {
        label: "Copier",
        role: 'copy'
      },
      {
        label: "Coller",
        role: 'paste'
      },
      {
        label: "Coller et appliquer le style",
        role: 'pasteandmatchstyle'
      },
      {
        label: "Supprimer",
        role: 'delete'
      },
      {
        label: "Sélectionner tout",
        role: 'selectall'
      }
    ]
  },
  {
    label: 'Présentation',
    submenu: [
      {
        label: 'Recharger',
        accelerator: 'CmdOrCtrl+R',
        click: (item, focusedWindow) ->
          focusedWindow.reload() if focusedWindow
      },
      {
        label: 'Afficher/cacher l\'inspecteur',
        accelerator: if process.platform is 'darwin' then 'Alt+Command+I' else 'Ctrl+Shift+I',
        click: (item, focusedWindow) ->
            focusedWindow.webContents.toggleDevTools() if focusedWindow
      },
      {
        type: 'separator'
      },
      {
        label: 'Activer/désactiver le plein-écran'
        role: 'togglefullscreen'
      }
    ]
  },
  {
    label: 'Fenêtre',
    role: 'window',
    submenu: [
      {
        role: 'minimize'
      },
      {
        role: 'close'
      }
    ]
  }
]

if process.platform is 'darwin'
  name = require('electron').app.getName()
  template.unshift({
    label: name,
    submenu: [
      {
        role: 'about'
      },
      {
        type: 'separator'
      },
      {
        role: 'services',
        submenu: []
      },
      {
        type: 'separator'
      },
      {
        role: 'hide'
      },
      {
        role: 'hideothers'
      },
      {
        role: 'unhide'
      },
      {
        type: 'separator'
      },
      {
        role: 'quit'
      }
    ]
  })
  # Window menu.
  template[4] = {
      label: "Fenêtre",
      submenu: [
        {
          label: 'Fermer',
          accelerator: 'CmdOrCtrl+W',
          role: 'close'
        },
        {
          label: 'Réduire',
          accelerator: 'CmdOrCtrl+M',
          role: 'minimize'
        },
        {
          label: 'Zoom',
          role: 'zoom'
        },
        {
          type: 'separator'
        },
        {
          label: 'Tout ramener au premier plan',
          role: 'front'
        }
      ]
    }
module.exports = ->
    menu = Menu.buildFromTemplate template
    Menu.setApplicationMenu menu
