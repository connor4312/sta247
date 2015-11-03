SET search_path TO artistdb;

DROP VIEW IF EXISTS IndieCanadian;
DROP VIEW IF EXISTS FirstAlbums;
DROP VIEW IF EXISTS AmericanSigners;

CREATE VIEW FirstAlbums AS (
    SELECT * FROM Album
    WHERE year = (
        SELECT MIN(year)
        FROM Album as a2
        WHERE a2.artist_id = Album.artist_id));

CREATE VIEW IndieCanadian AS (
    SELECT Artist.*
    FROM Artist, Album
    WHERE Artist.artist_id = Album.artist_id AND
          Artist.nationality = 'Canada' AND
          Album.album_id IN (SELECT album_id FROM FirstAlbums) AND
          NOT EXISTS (SELECT 1 FROM ProducedBy
            WHERE ProducedBy.album_id = Album.album_id));

CREATE VIEW AmericanSigners AS (
    SELECT Artist.*
    FROM Artist, Album, ProducedBy, RecordLabel
    WHERE Artist.artist_id = Album.artist_id AND
          Album.album_id = ProducedBy.album_id AND
          ProducedBy.label_id = RecordLabel.label_id AND
          RecordLabel.country = 'America');


SELECT name artist_name FROM (
    (SELECT * FROM IndieCanadian)
    INTERSECT
    (SELECT * FROM AmericanSigners)
) t;
