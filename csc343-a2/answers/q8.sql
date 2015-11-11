SET search_path TO artistdb;

INSERT INTO WasInBand (artist_id, band_id, start_year, end_year)
SELECT artist_id, band_id, 2014, 2015
FROM WasInBand
WHERE band_id = (SELECT artist_id band_id FROM Artist WHERE name = 'AC/DC');


-- For testing purposes only:
-- SELECT * FROM WasInBand;
-- DELETE FROM WasInBand WHERE artist_id = 40 AND band_id = 11 AND start_year = 2014 AND end_year = 2015;
