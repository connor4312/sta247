<Movies>{
  for $movie in doc('a3/movies.xml')/Movies/Movie
    return <Movie id="{data($movie/@MID)}" actors="{count($movie/Actors/Actor)}"></Movie>
}</Movies>