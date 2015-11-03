SET search_path TO artistdb;

DROP VIEW IF EXISTS ColSales;
DROP VIEW IF EXISTS ColAlbum;

CREATE VIEW ColAlbum as (
    SELECT Album.*
    FROM Collaboration, Album, BelongsToAlbum
    WHERE Collaboration.song_id = BelongsToAlbum.song_id AND
          BelongsToAlbum.album_id = Album.album_id);

CREATE VIEW ColSales as (
    SELECT AVG(sales) avg, artist_id
    FROM ColAlbum c
    GROUP BY artist_id);


SELECT name, avg avg_collab_sales FROM Artist, Album, ColSales
WHERE Album.artist_id = Artist.artist_id AND
      ColSales.artist_id = Artist.artist_id AND
      Album.album_id NOT IN (SELECT album_id FROM ColAlbum) AND
      Album.sales < (
          SELECT avg
          FROM ColSales
          WHERE Artist.artist_id = ColSales.artist_id)
ORDER BY name ASC;
