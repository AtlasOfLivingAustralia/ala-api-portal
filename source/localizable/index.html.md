---
title: Atlas of Living Australia API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - ruby
  - python
  - javascript

toc_footers:
  - <a href='https://github.com/slatedocs/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true

code_clipboard: true

meta:
  - name: description
    content: Documentation for the Atlas of Living Australia API
---

# Introduction

The Atlas of Living Australia (ALA) is Australia’s national biodiversity database. We provide free, online access to information about Australia’s amazing biodiversity. The ALA is collaborative – the data contained within the ALA have been aggregated from multiple sources, making the information accessible and reusable.  

These data stored in the ALA have been fully parsed, processed and augmented with consistent taxonomic, geolocation and climate/environmental data. Our data API provides access to over 100 million species occurrence records as well as taxonomic and scientific name information for over 153,000 species, complete with geospatial, taxonomic and temporal searching & filtering as well as bulk downloads for use ‘offline’. 

# API Portfolio Hub 

Welcome to the ALA API Portfolio Hub.  

We’ve recently moved to this API Gateway to improve security access for end-users by incorporating user authentication. ALA data is still open and freely accessible. 

Previously, if a user created a dataset, they were unable to make edits later. The move to this API gateway means that it’s now increasingly possible to update your data (rolling out across the various APIs gradually). 

<any other benefits we should mention?> 
 
For more information or assistance, please contact support@ala.org.au. 

API Endpoint: <%= I18n.t(:baseUrl) %>

# Authentication

A JWT access token is used to authenticate requests to the ALA APIs. 

Open ID connect is used to obtain an access token, once an access token is obtained is should be passed as an bearer token in the HTTP Authentication header.

`Authorization: Bearer <access_token>`

## Client Credentials

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# Exchange the client credentials (client ID & secret) for an access token
curl --user {clientId}:{clientSecret}  -X POST -d 'grant_type=client_credentials' -d 'scope={scope}' https://ala-test.auth.ap-southeast-2.amazoncognito.com/oauth2/token

# Use the access_token in the Authorization header
curl "api_endpoint_here" \
  -H "Authorization: Bearer {access_token}"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

>

`POST <%= I18n.t(:authBaseUrl) %>/token`

Header Parameters:

Parameter | Mandetory | Default | Description
--------- | --------- | ------- | -----------
Authorization | Y | | base64 encoded `<clientId>:<clientSecret>`
Content-Type | Y | | `application/x-www-form-urlencoded`

Request Parameters:

Parameter | Mandetory | Default | Description
--------- | --------- | ------- | -----------
grant_type | Y | | Set to `client_credentials`
scope | N | | A space separated list of scopes that have been approved for the API Authorization client. These scopes will be included in the Access Token that is returned.

# Products

## Species profile

Lookup by species (taxonomic name), including bulk species lookup, and downloads for both. You can also get a list of higher taxa for a requested taxon. 

## Occurrence  

Search and download occurrence records for specific groups, including a faceted search. There is also an option to ingest data. 

### Search Occurrence records

`GET <%= I18n.t(:baseUrl) %>/occurrences/search`

Query Parameters

Parameter | Mandetory | Default | Description
--------- | --------- | ------- | -----------
q | N |	\*:\* | Query of the form field:value e.g. q=genus:Macropus or a free text search e.g. q=Macropus
fq | N | | Filters to be applied to the original query. These are additional params of the form fq=INDEXEDFIELD:VALUE e.g. fq=kingdom:"Fungi". See <%= I18n.t(:baseUrl) %>/occurrences/index/fields for all the fields that a queryable.
facet	| N | |	Supported values are "off" or "on". By default, its "on". This is worth switching off if facetting is not required, to reduce the JSON being sent.
facets | N | | Comma separated list of the fields to create facets on e.g. facets=basisOfRecord.
pageSize| N | 10 | Number of records to return
start	| N | 0 | Record offset, to enable paging
sort | N | score | 	The indexed field to sort by
dir	| N | asc | Supports "asc" or "desc"
flimit | N | | Maximum number of facet values to return
fsort	| N | | Method in which to sort the facets either "count" or "index"
foffset	| N | | Facet offset, to enable paging
fprefix	| N | | Limits facets to values that start with the supplied value
lat	| N | | The decimal latitude to limit records to. Use with lon and radius to specify a "search" circle
lon	| N | | The decimal latitude to limit records to. Use with lon and radius to specify a "search" circle
radius | N | | The radius in which to limit records (relative to the lat, lon point). Use with lat and lon to specify a "search" circle.
wkt	| N | | The polygon area in which to limit records. For information on Well known text see [https://en.wikipedia.org/wiki/Well-known_text](https://en.wikipedia.org/wiki/Well-known_text)

### Get Occurrence record

Retrieve the full details of a occurrence record.

`GET <%= I18n.t(:baseUrl) %>/occurrences/{uuid}`

### Occurrence assertions

for full api documentation see: [<%= I18n.t(:biocacheBaseUrl) %>/openapi](<%= I18n.t(:biocacheBaseUrl) %>/openapi)

## Geospatial

Get a list of gridded, shape or all layers, or a list of geospatial fields. Download a shape object, upload geometry objects and shapefiles, create and work with points of interest, and get a region list. 

## Mapping

Create maps with WMS services and generate static heat maps. 

## Endemism

Count endemic species within an area and generate endemic species lists. 

## Parsing  

Test, match and map Darwin Core terms, and parse ad hoc occurrence data. 

## Collections  

Get or update collections metadata, and generate lists and citations.  

## Data resources  

Get a list of data resources, and metadata for each. Obtain metadata for species lists, and data licenses. 

## Data providers  

Get a list of data providers, and metadata for each.  

## Institution  

Get a list of institutions, and metadata for each. 

## Crowd sourcing  

A range of reports available from the volunteer portal, including lists of expeditions, user contributions, transcriptions per month, and validations per month. 

## Auto complete  

Get a list of scientific or common names that can be used to automatically complete a supplied partial name in searches. 

## General data  

Get general and miscellaneous data on the ALA, such as metadata for a species list, layer information, ALA dashboard data, region list, or a list of data licenses. 

## Taxonomy  

Lookup the details of a name, and get a list of higher taxa for GUID. 

## Distributions  

Count all distributions by family, get a list of distributions, including by radius. Create an expert distribution map (currently for fish and birds only), and perform an outlier test.  

## Tabulations  

Get a list of tabulations available in the Spatial Portal. 

## Breakdowns  

Perform a breakdown of the collector type, and get a regions list. 

## Annotations  

Get or add an assertion to a record, or generate a list of assertion codes with short descriptions. 

## Scatterplot  

Generate a scatterplot for occurrence data and up to two environmental layers. 

## Species lists  

Create a new species list, search lists and retrieve species list metadata.  

## Multimedia/images  

Access images and sound recordings from the ALA. 

## User details

#### GET /ws/flickr
Lists all flickr profiles known to the application, including their ala id, flickr id, username and their flickr URL

HTTP Request
GET <%= I18n.t(:baseUrl) %>/userdetails/ws/flickr

```shell
curl <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/ws/flickr -H "Authorization: Bearer {access_token}
```

#### GET /ws/getProperty
Gets a count of all users in the system, including the number locked and activated. In addition it also provides a count of users from one year ago.

HTTP Request
GET <%= I18n.t(:baseUrl) %>/userdetails/ws/getProperty

```shell
curl <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/ws/getProperty
```

#### GET /userDetails/byRole
Get Users by Role

HTTP Request
GET <%= I18n.t(:baseUrl) %>/userdetails/userDetails/byRole

Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
role | Y | | `ROLE_ADMIN`
id | N | | 
includeProps | N | false | true/false

```shell
curl <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/userDetails/byRole?role=role -H "Authorization: Bearer {access_token}"
```

#### POST /userDetails/getUserDetails
Get User Details

HTTP Request
POST <%= I18n.t(:baseUrl) %>/userdetails/userDetails/getUserDetails

Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
userName | Y | | email_or_userid
includeProps | N | false | true/false

```shell
curl -X POST <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/userDetails/getUserDetails?userName=userName -H "Authorization: Bearer {access_token}"
```

#### POST /userDetails/getUserDetailsFromIdList
Get a list of user details for a list of user ids

HTTP Request
POST <%= I18n.t(:baseUrl) %>/userdetails/userDetails/getUserDetailsFromIdList

```shell
curl -X POST -H "Content-Type: application/json" \
-d '{"userIds": ["0"], "includeProps": true}' \ 
<%= I18n.t(:userdetailsBaseUrl) %>/userdetails/userDetails/getUserDetailsFromIdList -H "Authorization: Bearer {access_token}"
```

#### GET /userDetails/search
Search for users by username, email or display name.

HTTP Request
GET <%= I18n.t(:baseUrl) %>/userdetails/userDetails/search

Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q | Y | | 
max | N | | 

```shell
curl <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/userDetails/search?q=username -H "Authorization: Bearer {access_token}"
```

#### GET /property/getProperty
Get a property value for a user

HTTP Request
GET <%= I18n.t(:baseUrl) %>/userdetails/property/getProperty

Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
alaId | Y | | The user's ALA ID
name | Y | | The name of the property to get

```shell
curl <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/property/getProperty?alaId=alaId&name=name -H "Authorization: Bearer {access_token}"
```

#### POST /property/saveProperty
Saves a property value for a user

HTTP Request
POST <%= I18n.t(:baseUrl) %>/userdetails/property/saveProperty

Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
alaId | Y | | The user's ALA ID
name | Y | | The name of the property to get
value | Y | | The value of the property to set

```shell
curl <%= I18n.t(:userdetailsBaseUrl) %>/userdetails/property/saveProperty?alaId=alaId&name=name&value=value -H "Authorization: Bearer {access_token}"
```

For full api documentation see: [<%= I18n.t(:userdetailsBaseUrl) %>/openapi](<%= I18n.t(:userdetailsBaseUrl) %>/openapi)

