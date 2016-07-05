Short description of the CBSparser.py script to collect data from CBS tables.

The script sequentially parses the XML files returned by the CBS data feed, stores it in a Pandas DataFrame, and then saves to CSV with pipe separator.

It uses the following libraries:
- pandas
- urllib2
- xml.etree.ElementTree
- re


## ABOUT CBS OPEN DATA
CBS uses the OData platform to make its many tables available. The API returns at most 10000 records, but the XML Data Feed (or RSS) can return all required records (10000 at a time). It uses OData's Atom namespace and structuring convention.

Explanation about the different feeds:
https://www.cbs.nl/-/media/statline/documenten/handleiding-cbs-opendata-services.pdf?la=en-gb

In the below link you can look for the Table you want to download, where the description contains the data feed link you need, under 'Feed (bulk download)':
http://opendata.cbs.nl/dataportaal/portal.html?_la=nl&_catalog=CBS

The one used in the CBSparser.py script is as follows, but can be changed as desired to another from the portal:
http://opendata.cbs.nl/dataportaal/portal.html?_la=nl&_catalog=CBS&tableId=83220NED&_theme=404