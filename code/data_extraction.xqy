xquery version "3.1";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace xi="http://www.w3.org/2001/XInclude";
declare namespace wib="https://wibarab.acdh.oeaw.ac.at/langDesc";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace space="preserve";
declare namespace schemaLocation="http://www.tei-c.org/ns/1.0 ../../804_xsd/1.0.0/featuredb.xsd";

declare variable $output_path := "C:\Users\User\Documents\GitHub\acdh\output\"; (: for output file, here you have to change your path if necessary :)
declare variable $output_filename := "data_extraction.xml"; (: for output file, here you have to change the filename if necessary :)
declare variable $files := collection("..\features"); (: for input files, here you have to change your path if necessary :)
declare variable $features := $files//wib:featureValueObservation;
declare variable $geodata := doc("..\references\vicav_geodata.xml")//place; (: for the geodata file, here you have to change your path if necessary :)
declare variable $biblio := doc("..\references\vicav_biblio_tei_zotero.xml")//biblStruct; (: for the biblio file, here you have to change your path if necessary :)


declare function local:PlaceIndex(){
  
  <task>
  <question>1. the index of all mentioned places </question>
  <results>
  { 
    for $placedata in $geodata where $placedata/@xml:id = $features/placeName/substring-after(@ref, ':')
    return (<place><placeName>{data($placedata/@xml:id)}</placeName><placeIndex>{data($placedata/idno)}</placeIndex></place>) 
  }
  </results>
  </task>
};


declare function local:DialectSummary(){
  <task>
  <question>2. a summary of all feature value observations associated with each dialect </question>
  <results>
  {
    for $feature in $features
    let $dialect := $feature/lang/@corresp
    group by $dialect
    order by $dialect (: if needed :)
    return element result {element dialect {$dialect}, element count {count($feature)}} (: number of featureValueObservations for each dialect :)
    (: below is my first version which shows all featureValueObservations for each dialect :)
    (: 
    let $info := $feature where $dialect=$feature/lang/@corresp 
    return element result {element dialect {$dialect}, element summary {$info}}
    :)
  }
  </results>
  </task>
};

declare function local:BibliographyType(){
  <task>
  <question>3. Which types of bibliographic items are used most? </question>
  <results>
  {
    
    for $feature in $features
    let $type := normalize-space(lower-case($feature/bibl/@type))
    
    let $var := 
    if ($type = "publication") then
      for $entry in $biblio
      return
      if ($feature/bibl/substring-after(@corresp, ':') = $entry/@n) then
        ($entry/@type)
      else
        ()
    else
      ($type)
    group by $var
    order by count($feature) descending
    return (<bibliographicItem><type>{$var}</type><count>{count($feature)}</count></bibliographicItem>)
  }
  </results>
  </task>
};
(: if PC/pc means personalcommunication it should be adjusted accordingly. 
The most used bibliographic items are books by far, followed by journalarticles and theses :)


declare function local:FeaturesWithTribes() {
  <task>
  <question>4. Which features are associated with tribes? </question>
  <results>
  {
    (: 1. possibility: Which documents are associated with tribes :)
    for $file in $files where $file//wib:featureValueObservation/personGrp/@role = "tribe"
    return (<DocumentWithTribes>{tokenize(fn:base-uri($file),'/')[last()]}</DocumentWithTribes>) (: all of them contain tribes :)
    (: 2. possibility: ref of featureValueObservation = id of featureValue :)
    (:   
    for $feature in $features
    let $ref := $feature/name/@ref where $feature/personGrp/@role = "tribe"
    group by $ref
    order by $ref
    return (<FeatureValueID>{$ref}</FeatureValueID>)
    :)
  }
  </results>
  </task>
};


let $res1 := local:PlaceIndex()
let $res2 := local:DialectSummary()
let $res3 := local:BibliographyType()
let $res4 := local:FeaturesWithTribes()

return file:write(concat($output_path, $output_filename), <report>{$res1, $res2, $res3, $res4}</report>)



(: 5. Do you find documents which cannot be parsed because of well-formedness errors? :)
(: It seemed as if all the 69 documents in the feature folder got properly parsed :)

(: 6. Do you find broken pointers which cannot be resolved? :)
(: Within these tasks I didn't stumble over broken pointers :)