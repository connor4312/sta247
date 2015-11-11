SET search_path TO artistdb;

DROP VIEW IF EXISTS CountedGenres;
DROP VIEW IF EXISTS ExploredGenres;
DROP VIEW IF EXISTS WrittenGenres;

CREATE VIEW WrittenGenres AS (
    SELECT genre_id, songwriter_id artist_id
        FROM Album, Song, BelongsToAlbum
        WHERE BelongsToAlbum.album_id = Album.album_id
          AND BelongsToAlbum.song_id = Song.song_id);

CREATE VIEW ExploredGenres AS (
    (SELECT genre_id, artist_id, 'Musician' capacity FROM Album
        WHERE artist_id NOT IN (SELECT band_id FROM WasInBand))
    UNION
    (SELECT genre_id, artist_id, 'Band' capacity FROM Album
        WHERE artist_id IN (SELECT band_id FROM WasInBand))
    UNION
    (SELECT *, 'Songwriter' capacity FROM WrittenGenres
        WHERE artist_id NOT IN (SELECT band_id FROM WasInBand)));

CREATE VIEW CountedGenres AS (
    SELECT name artist, capacity, COUNT(DISTINCT genre_id) genres
    FROM ExploredGenres, Artist
    WHERE Artist.artist_id = ExploredGenres.artist_id
    GROUP BY Artist.artist_id, capacity);


SELECT * FROM CountedGenres
WHERE genres >= 3
ORDER BY (case
    when capacity = 'Musician'   then 1
    when capacity = 'Band'       then 1
    when capacity = 'Songwriter' then 2
end), genres DESC, artist ASC;
