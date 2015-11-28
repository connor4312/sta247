<Movies>{
  let $theJames := (
    for $person in doc('a3/people.xml')/People/Person
    where $person/Name/First = "James" and $person/Name/Last = "Cameron"
    return data($person/@PID)
  )
  
  for $movie in doc('a3/movies.xml')/Movies/Movie
    where $movie/Director/@PID = $theJames
    return $movie
}</Movies>