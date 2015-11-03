SET search_path TO artistdb;

DROP VIEW IF EXISTS CountedGenres;
DROP VIEW IF EXISTS ExploredGenres;

CREATE VIEW ExploredGenres AS (
    (SELECT genre_id, artist_id, 'Musician' capacity FROM Album)
    UNION
    (SELECT genre_id, songwriter_id artist_id, 'Songwriter' capacity
        FROM Album, Song, BelongsToAlbum
        WHERE BelongsToAlbum.album_id = Album.album_id AND
              BelongsToAlbum.song_id = Song.song_id));

CREATE VIEW CountedGenres AS (
    SELECT COUNT(DISTINCT genre_id) genres, capacity, name artist
    FROM ExploredGenres, Artist
    WHERE Artist.artist_id = ExploredGenres.artist_id
    GROUP BY Artist.artist_id, capacity);


SELECT * FROM CountedGenres
WHERE genres >= 3
ORDER BY capacity ASC, genres DESC, artist ASC;
