const axios = require('axios')

const fetchAlbum = title =>
  // prettier-ignore
  axios.get(`http://localhost:3001/albums/${title}`)
    .then(({ data }) => data)

const printAlbum = ({ title, artists }) =>
  console.log(`${title} by ${artists.join(' - ')}`)

// prettier-ignore
fetchAlbum('blue train')
  .then(printAlbum)
  .catch(e => console.error(e))
