<MultiTalented>{ 
  let $actors := doc('a3/movies.xml')/Movies/Movie/Actors/Actor/@PID
  let $directors := doc('a3/movies.xml')/Movies/Movie/Director/@PID
  
  for $person in doc('a3/people.xml')/People/Person
    where $person/@PID = $actors and $person/@PID = $directors
    return <Person PID="{data($person/@PID)}" lastName="{data($person/Name/Last)}"></Person>
}</MultiTalented>