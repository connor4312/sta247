SET search_path TO artistdb;

DROP VIEW IF EXISTS Songwritten;
CREATE VIEW Songwritten as (
    SELECT Album.album_id
    FROM Album, BelongsToAlbum, Song
    WHERE Song.song_id = BelongsToAlbum.song_id
      AND BelongsToAlbum.album_id = Album.album_id
      AND Song.songwriter_id != Album.artist_id);

SELECT name artist_name, title as album_name
FROM Artist, Album
WHERE Album.artist_id = Artist.artist_id
  AND Album.album_id NOT IN (SELECT album_id FROM Songwritten)
ORDER BY artist_name ASC, album_name ASC;
