/* LISTADO DE CANCIONES DE UN ALBUM */

 db.songs.aggregate([
  {
    $match: {
      album: ObjectId("tuAlbumId")
    }
  },
  {
    $lookup: {
      from: "albums",
      localField: "album",
      foreignField: "_id",
      as: "albumInfo"
    }
  },
  {
    $unwind: "$albumInfo"
  },
  {
    $sort: {
      track: 1 // Ordena ascendentemente por el campo "track"
    }
  }
])

/*Obtener todos los álbumes de un artista específico con sus canciones:*/

db.albums.aggregate([
  {
    $match: {
      artist: ObjectId("idDelArtista") // Reemplaza con el ID del artista deseado
    }
  },
  {
    $lookup: {
      from: "songs",
      localField: "_id",
      foreignField: "album",
      as: "songs"
    }
  }
])

/*Buscar todas las canciones que superen cierta duración:*/

db.songs.find({
  duration: { $gt: 300 } // Filtra canciones con duración mayor a 300 segundos
})

/*Obtener el artista con mas almbunes*/

db.albums.aggregate([
  {
    $group: {
      _id: "$artist",
      totalAlbums: { $sum: 1 }
    }
  },
  {
    $sort: { totalAlbums: -1 }
  },
  {
    $limit: 1
  },
  {
    $lookup: {
      from: "artists",
      localField: "_id",
      foreignField: "_id",
      as: "artistInfo"
    }
  }
])


/*Buscar álbumes que contengan canciones con un título específico:*/
db.albums.aggregate([
  {
    $lookup: {
      from: "songs",
      localField: "_id",
      foreignField: "album",
      as: "songs"
    }
  },
  {
    $match: {
      "songs.title": "Título de la Canción"
    }
  }
])

/*Encontrar canciones en un rango de años de lanzamiento de álbumes:*/

db.albums.aggregate([
  {
    $match: {
      year: { $gte: 2010, $lte: 2020 } // Álbumes lanzados entre 2010 y 2020
    }
  },
  {
    $lookup: {
      from: "songs",
      localField: "_id",
      foreignField: "album",
      as: "songs"
    }
  },
  {
    $unwind: "$songs"
  },
  {
    $match: {
      "songs.created_at": { $gte: ISODate("2010-01-01T00:00:00Z"), $lte: ISODate("2020-12-31T23:59:59Z") }
    }
  }
])
