# Welcome to my submission
This repository contains the code for the Assessment Task "Data Extraction from XML".  
I hope you will enjoy the content.  

Sincerely,  
Michaela Rausch-Supola

## Setup dependencies
- Java 17 - https://www.oracle.com/java/technologies/downloads/#jdk17-windows  
- BaseX 10.7 - https://basex.org/download/

## Usage
- Copy the WIBARAB data into a folder named features inside the main folder, or adjust the path of the features in the code (line 12)
- Copy the file for the bibliographic data and the geodata into a folder named references inside the main folder, or adjust the path of the references in the code (line 14 and 15)    
- Adjust your folder path for the output XML file (line 10)

## Additional information
- Query languages are usually not the best fit for assessing broken pointers. For a clear use case, my approach would be to run a python script and check for all the relevant aspects of the references.
- I also ran the provided jupyter notebook in the original repo (validate.ipynb), and included the resulting DataFrame of errors in a csv file in the validation folder.
- The changes in the repo impacted the extraction of bibliographical data (@n or @xml:id). In a project setting, I would have clarified the usage, however with the current time constraints, it is almost certain that the results are affected by the modifications. The queries have been run on the version of features data pulled at the beginning of the challenge (and have entries such as dickins_2009_3089 as well as in the @n format).
- Also in the bibliographic items, for the solution I left the <type> field empty where no equivalent type was found in the reference file. For a report, I would clarify if there was a need for any replacement.
- Please note that I did not include your data in the repo because of copyrights.

### Applied approach
- Though XQuery is not my first language (being Python), I used it for the data extraction, as this solution seemed most compatible for the job-role and is listed as prefered on the assignment sheet.
- The report has been created in XML format because of the same reason as above
- The original repo has been changed significantly during the course of this time period. While projects might require continous adaptation on peer commits, I did stick with my pulled version.
