xquery version "1.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace xi="http://www.w3.org/2001/XInclude";
declare namespace wib="https://wibarab.acdh.oeaw.ac.at/langDesc";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace space="preserve";
declare namespace schemaLocation="http://www.tei-c.org/ns/1.0 ../../804_xsd/1.0.0/featuredb.xsd";
declare namespace id="ft_akl_3sgm_pfv_ipv";

(:doc("feature_AKL_3sgm_pfv_ipv.xml")//placeName/@ref:)

for $type in doc("features/feature_AKL_3sgm_pfv_ipv.xml")//wib:featureValueObservation/bibl/@type
return $type
