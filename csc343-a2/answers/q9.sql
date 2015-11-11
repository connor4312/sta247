SET search_path TO artistdb;

UPDATE WasInBand SET end_year = 2014 WHERE artist_id IN (
    SELECT artist_id
    FROM Artist
    WHERE name = 'Mick Jagger'
       OR name = 'Adam Levine');

INSERT INTO WasInBand (artist_id, band_id, start_year, end_year)
SELECT artist.artist_id, band.artist_id, 2014, 2015
FROM Artist artist, Artist band
WHERE artist.name = 'Mick Jagger'
  AND band.name = 'Maroon 5';
