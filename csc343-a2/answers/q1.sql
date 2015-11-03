SET search_path TO artistdb;

SELECT name, nationality FROM Artist
WHERE EXTRACT(YEAR FROM birthdate) = (
    SELECT year FROM Album, Artist
    WHERE Album.artist_id = Artist.artist_id AND
          Artist.name = 'Steppenwolf'
    ORDER BY year ASC
    LIMIT 1
)
ORDER BY name ASC;
