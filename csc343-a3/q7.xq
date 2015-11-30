<Stats>{ 
  let $categories := data(doc('a3/movies.xml')/Movies/Movie/Genre/Category)
  for $category in distinct-values($categories)
    return <Bar category="{$category}" count="{
      count(for $c in $categories where $c = $category return $c)
    }"></Bar>
}</Stats>