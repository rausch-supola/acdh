xquery version "3.1";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace xi="http://www.w3.org/2001/XInclude";
declare namespace wib="https://wibarab.acdh.oeaw.ac.at/langDesc";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace space="preserve";
declare namespace schemaLocation="http://www.tei-c.org/ns/1.0 ../../804_xsd/1.0.0/featuredb.xsd";

declare variable $path := "C:\Users\User\Documents\GitHub\acdh\"; (: here you have to change your path if necessary :)
declare variable $files := collection("features");
declare variable $features := $files//wib:featureValueObservation;


declare function local:PlaceIndex(){
(: I understood the task as to once assign an index to every place occurring in all the documents
aso to indexing all the places like a datatable :)
  <task>
  <question>1. an index of all mentioned places </question>
  <results>
  {
    for $feature in $features
    let $place := $feature/placeName/@ref where (count($place) lt 2)
    group by $place
    order by $place (: if needed :)
    count $n
    return (<place><placeName>{$place}</placeName><placeIndex>{$n}</placeIndex></place>)
    (:
    return (<place index="{$n}"><placeName>{$place}</placeName></place>) (: or index as attribute :)
    :)
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
    let $info := $feature where $dialect=$feature/lang/@corresp
    return element result {element dialect {$dialect}, element summary {$info}}
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
    group by $type
    order by count($feature) descending
    return (<bibliographicItem><type>{$type}</type><count>{count($feature)}</count></bibliographicItem>)
  }
  </results>
  </task>
};
(: if PC/pc means personalcommunication it should be adjusted accordingly. 
The most used bibliographic items are publications by far, followed by fieldword and personal communication :)


declare function local:FeaturesWithTribes() {
  <task>
  <question>4. Which features are associated with tribes? </question>
  <results>
  {
    for $feature in $features
(: 1. possibility: id of featureValueObservation :)
(:
let $id := $feature/@xml:id where $feature/personGrp/@role = "tribe"
return <ref> {$id} </ref> 
:)
(: 2. possibility: ref of featureValueObservation = id of featureValue :)
    let $ref := $feature/name/@ref where $feature/personGrp/@role = "tribe"
    group by $ref
    order by $ref
    return (<FeatureValueID>{$ref}</FeatureValueID>)
  }
  </results>
  </task>
};


let $res1 := local:PlaceIndex()
let $res2 := local:DialectSummary()
let $res3 := local:BibliographyType()
let $res4 := local:FeaturesWithTribes()
(:return <report>{($res1, $res2, $res3, $res4)}</report>:)
return file:write(concat($path,"data_extraction.xml"), <report>{$res1, $res2, $res3, $res4}</report>)



(: 5. Do you find documents which cannot be parsed because of well-formedness errors? :)
(: only duplicates :)

(: 6. Do you find broken pointers which cannot be resolved? :)
(: Not sure yet. :)