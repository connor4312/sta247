<FilmOscars>{
  for $movie in doc('a3/movies.xml')/Movies/Movie
    for $oscar in $movie/Oscar/@OID
      let $awards := doc('a3/oscars.xml')/Oscars/Oscar[@OID=data($oscar)]
      let $first := min($awards/@year)
      for $award in $awards
        where $award/@year = $first
        return <Oscar>
          {$award/Type}
          <FirstYear>{$first}</FirstYear>
          {$movie/Title}
        </Oscar>
}</FilmOscars>