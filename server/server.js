const express = require('express')
const cors = require('cors')

const MIDDLEWARE_SYM = Symbol()

function createMiddleware(fn) {
  fn[MIDDLEWARE_SYM] = true
  return fn
}

exports.middleware = {
  cors: createMiddleware(() => cors()),
  static: createMiddleware(path => express.static(path)),
  delay: amount =>
    createMiddleware((req, res, next) => setTimeout(next, amount)),
}

exports.create = function create({ ports }) {
  const server = express()

  function get(path, ...handlers) {
    const {
      middlewareBefore,
      createRequest,
      middlewareAfter,
    } = handlers.reduce(
      (accum, handler) => {
        if (handler[MIDDLEWARE_SYM] && !accum.createRequest) {
          return {
            ...accum,
            middlewareBefore: accum.middlewareBefore.concat(handler),
          }
        } else if (handler[MIDDLEWARE_SYM] && accum.createRequest) {
          return {
            ...accum,
            middlewareAfter: accum.middlewareAfter.concat(handler),
          }
        } else {
          return { ...accum, createRequest: handler }
        }
      },
      { middlewareBefore: [], createRequest: null, middlewareAfter: [] },
    )

    server.get(
      path,
      ...middlewareBefore,
      (req, res) => {
        const request = createRequest(req)

        function handler(response) {
          ports.reply.unsubscribe(handler)

          if (response.id === request.id && response.payload) {
            res.send(response.payload)
          } else {
            res.status(404).send('Not Found')
          }
        }

        ports.reply.subscribe(handler)
        ports.request.send(request)
      },
      ...middlewareAfter,
    )
  }

  function listen(port) {
    server.listen(port, () => {
      console.log(`Server listening at http://localhost:${port}`)
    })
  }

  const use = (...middleware) => server.use(...middleware)

  return {
    get,
    listen,
    use,
  }
}
