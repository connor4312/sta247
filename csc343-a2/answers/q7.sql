SET search_path TO artistdb;

-- For this I am assuming that the oldest song by year is
-- the original, and covers cannot come in the same year.

DROP VIEW IF EXISTS Covered;
CREATE VIEW Covered AS (
    SELECT COUNT(*) as covers, Song.song_id, title
    FROM BelongsToAlbum, Song
    WHERE BelongsToAlbum.song_id = Song.song_id
    GROUP BY Song.song_id
    HAVING COUNT(*) > 1);

SELECT Covered.title song_name, Album.year, Artist.name artist_name
FROM Covered, BelongsToAlbum, Album, Artist
WHERE BelongsToAlbum.album_id = Album.album_id
  AND Album.artist_id = Artist.artist_id
  AND BelongsToAlbum.song_id = Covered.song_id
ORDER BY song_name ASC, year ASC, artist_name ASC;
