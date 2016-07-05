import pandas as pd
import urllib2
import xml.etree.ElementTree as ET
import re

# url that one wishes to parse
url = 'http://opendata.cbs.nl/ODataFeed/odata/83220NED/TypedDataSet'


# function that removes namespace redundancy
def parse_brackets(v):
    return re.sub('{.*?}', '', v)


# function that parses a given CBS table link,
# storing the table in a Pandas DataFrame
def CBSparser(url):
    
    # open and parse url with OData namespace, extract root
    u = urllib2.urlopen(url)
    ns = 'http://www.w3.org/2005/Atom'
    tree = ET.parse(u)
    root = tree.getroot()
    
    # iterate over Atom entries, storing data in a dictionary (fastest method)
    iterDocs = root.findall("{%s}entry" % ns)
    docList = []
    for doc in iterDocs:
        iterRecords = doc.find("{%s}content" % ns)[0]
        iterDict = {}
        for record in iterRecords:
            iterDict[parse_brackets(record.tag)] = record.text
        docList.append(iterDict)
    
    df0 = pd.DataFrame(docList)
    
    # reorder the column headers (due to dictionary randomization)
    egContent = root.findall("{%s}entry" % ns)[0].find("{%s}content" % ns)[0]
    columnOrder = []
    for record in egContent:
        columnOrder.append(parse_brackets(record.tag))
    
    df = df0[columnOrder]
    
    return df


# function that repeats the feed call until all data is collected
# repetition is done in case table length > 10000
def parseIterator(url):
    
    repeat = True
    dfs = []
    nrow = 1
    
    while repeat == True:
        df = CBSparser(url)
        dfs.append(df)
        
        if len(df) == 10000:
            nrow += 10000
            skip = '?$skip=' + str(nrow)
            url = url + skip
        else:
            repeat = False
    
    outFrame = dfs[0]
    for frames in dfs[1:]:
        outFrame = outFrame.append(frames)
    
    return outFrame


# running the functions, and writing to CSV
dataFrame = parseIterator(url)
dataFrame.to_csv("WijkenEnBuurten.csv",sep="|",encoding='utf-8')
