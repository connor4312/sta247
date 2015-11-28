<Homeless>{
  let $directors := (
    for $director in doc('a3/movies.xml')/Movies/Movie/Director
    return $director/@PID
  )
  
  for $person in doc('a3/people.xml')/People/Person
    where $person[not(@dob)] and $person/@PID = $directors
    return <Person lastName="{$person/Name/Last}" id="{$person/@PID}"></Person>
}</Homeless>