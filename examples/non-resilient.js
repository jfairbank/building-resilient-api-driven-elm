const axios = require('axios')

const fetchAlbum = name =>
  // prettier-ignore
  axios.get(`http://localhost:3001/albums/${name}`)
    .then(({ data }) => data)

const printAlbum = ({ name, artists }) =>
  console.log(`${name} by ${artists.join(' - ')}`)

// prettier-ignore
fetchAlbum('blue train')
  .then(printAlbum)
