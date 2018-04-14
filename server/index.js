const Server = require('./server')
const { albums } = require('./jazz-albums.json')
const { App } = require('./app')

const PORT = 3001

const app = App.Main.worker({ albums })
const server = Server.create(app)

server.use(Server.middleware.cors())
server.use(Server.middleware.static('public'))

const delay = Server.middleware.delay(400)

server.get('/albums/:title', delay, req => ({
  id: 'ALBUM',
  type: 'FIND_ALBUM',
  payload: req.params.title,
}))

server.get('/album-titles', req => ({
  id: 'ALBUM_TITLES',
  type: 'ALBUM_TITLES',
  payload: '',
}))

server.listen(PORT, () => {
  console.log(`Server listening at http://localhost:${PORT}`)
})
