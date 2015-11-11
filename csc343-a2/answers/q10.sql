SET search_path TO artistdb;

-- bro, do you even ON DELETE CASCADE?

DROP VIEW IF EXISTS ThrillingSongs;
DROP VIEW IF EXISTS Thriller;
CREATE VIEW Thriller as (SELECT album_id FROM Album where title = 'Thriller');
CREATE VIEW ThrillingSongs as (
    SELECT song_id FROM BelongsToAlbum WHERE album_id IN
        (SELECT * FROM Thriller));

DELETE FROM Collaboration WHERE song_id IN (SELECT * FROM ThrillingSongs);
DELETE FROM BelongsToAlbum WHERE album_id IN (SELECT * FROM Thriller);
DELETE FROM Song WHERE song_id IN (SELECT * FROM ThrillingSongs);
DELETE FROM ProducedBy WHERE album_id IN (SELECT * FROM Thriller);
