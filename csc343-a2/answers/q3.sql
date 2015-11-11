SET search_path TO artistdb;

SELECT label_name record_label, year, SUM(sales) total_sales
FROM Album, ProducedBy, RecordLabel
WHERE ProducedBy.album_id = Album.album_id
  AND ProducedBy.label_id = RecordLabel.label_id
GROUP BY RecordLabel.label_id, Album.year
ORDER BY record_label ASC, year ASC;
