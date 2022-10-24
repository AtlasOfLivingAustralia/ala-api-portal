---
title: Atlas of Living Australia API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - python

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

The Atlas of Living Australia (ALA) is Australia’s national biodiversity database. It is a collaborative, digital infrastructure that aggregates Australian biodiversity data from multiple sources, making the information open, accessible and reusable. The ALA delivers trusted data services for Australia, supporting world-class biodiversity research and decision-making. 

These data stored in the ALA have been fully parsed, processed and augmented with consistent taxonomic, geolocation and climate/environmental data. Our data API provides access to over 100 million species occurrence records as well as taxonomic and scientific name information for over 153,000 species, complete with geospatial, taxonomic and temporal searching & filtering as well as bulk downloads for use ‘offline’. 

# API Portfolio Hub 

Welcome to the ALA API Portfolio Hub.  

We’ve recently moved to this API Gateway to streamline access and improve security for end-users by incorporating user authentication. ALA data are still open and freely accessible. 


 
For more information or assistance, please contact support@ala.org.au. 

API Endpoint: https://apis.ala.org.au


ALA APIs allow three main methods of access

1. No Authentication - The majority of the API endpoints across all published ALA services do not require authentication and is open to public access.

2. API Key for Common and Frequently used APIs  - For a curated [list](https://www.postman.com/sushantcsiro/workspace/ala-common-apis/collection/23926959-f59627be-b952-4939-bdd9-3b16236c143c) of  APIs commonly used by the ALA, partners, and public users, an API key (which can be requested from ALA Support) is expected. Please note that this API key is not used for authentication but rather for usage tracking, monitoring, and rate limiting due to the expected high frequency of usage on these endpoints. The postman *'Run in Postman'* link below demonstrates the usage of these APIs with API key. Further usage documentation on these APIs can be found in the corresponding application sections (e.g. Alerts, Logger etc) under [Products](#products).

      [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/23926959-f59627be-b952-4939-bdd9-3b16236c143c?action=collection%2Ffork&collection-url=entityId%3D23926959-f59627be-b952-4939-bdd9-3b16236c143c%26entityType%3Dcollection%26workspaceId%3De9363855-ef16-46ba-bf16-cee7f7f2f8e9)


3. JWT Authentication/Advanced Access - For API endpoints that provide write access and read access to sensitive or private data, the requestor(user or machine) needs to be authenticated. JWT access token can used to authenticate requests. The [Authentication](#authentication) section provides details on JWT usage.

# Authentication

Open ID Connect is used to obtain an access token, once an access token is obtained it should be passed as a bearer token in the HTTP Authentication header.

`Authorization: Bearer <access_token>`

We support multiple ways to obtain an access token:
 
 - [Client Credentials](#client-credentials)
 - [Authentication Code Flow](#authentication-code-flow)
 - [Implicit Flow](#implicit-flow)

  The Postman Collection below shows some examples of the above token generation methods and the subsequent usage of the generated token.

 [![Run in Postman](https://run.pstmn.io/button.svg)](https://god.gw.postman.com/run-collection/23926959-0b42d403-9afd-415d-b431-99b4e37691a4?action=collection%2Ffork&collection-url=entityId%3D23926959-0b42d403-9afd-415d-b431-99b4e37691a4%26entityType%3Dcollection%26workspaceId%3De9363855-ef16-46ba-bf16-cee7f7f2f8e9)

 Which authentication method should I use?

**Machine to Machine (No end user)**

 Anytime the system is not concerned with end user identity then [Client Credentials](#client-credentials) should be used. The use case would be a headless client application that does not have the ability for user interaction. In this case the system may need to be authenticated however an end user will not.

**End User Authentication**

If the end user *does* need to be authenticated then [Authentication Code Flow](#authentication-code-flow) should be used. *How* you use Authentication Code Flow depends on whether the application client is public or private. Regardless of your client's publicity, [Proof Key for Code Exchange](https://oauth.net/2/pkce/) (or *PKCE*) can, and should, be used as an additional security measure when authenticating within your application. 

For <u>private</u> client applications (eg. server side web application), you will need a `clientId` and `clientSecret` in order to authenticate. Please contact [support@ala.org.au](mailto:support@ala.org.au) to obtain these.

For <u>public</u> client applications (eg. Single-Page or JavaScript application), you will just need a `clientId`. [Implicit Flow](#implicit-flow) can also be used for public client authentication, however [Authentication Code Flow using PKCE](#authentication-code-flow) is the recommended mechanism.

**Additional Resources**

See [Authentication Code Flow using PKCE - Examples](https://github.com/AtlasOfLivingAustralia/oidc-auth-examples)

See [https://auth0.com/docs/get-started/authentication-and-authorization-flow](https://auth0.com/docs/get-started/authentication-and-authorization-flow)

See [OIDC Authentication for R](https://search.r-project.org/CRAN/refmans/openeo/html/OIDCAuth.html)

<p>&#128274; indicates the relevant API is a protected API and it requires authentication.</p> 

## Discovery

> Example response:

```javascript
{
   "issuer":"https://auth.ala.org.au/cas/oidc",
   "scopes_supported":[
      "openid",
      "profile",
      "... more scopes",

   ],
   "claims_parameter_supported":true,
   "...metadata"
}
```


>

OpenID Connect includes a [discovery mechanism](https://swagger.io/docs/specification/authentication/openid-connect-discovery/), where metadata for an OpenID server can be accessed.

`GET <%= I18n.t(:authBaseUrl) %>/cas/oidc/.well-known`

Examples of what the metadata includes are:

- OpenID/OAuth Endpoints
- Supported Scopes & Claims
- Public Keys

## Client Credentials

> To authorize, use this code:

```shell
# Exchange the client credentials (client ID & secret) for an access token
curl --user {clientId}:{clientSecret}  -X POST -d 'grant_type=client_credentials' -d 'scope={scope}' https://ala-test.auth.ap-southeast-2.amazoncognito.com/oauth2/token

# Use the access_token in the Authorization header
curl "api_endpoint_here" \
  -H "Authorization: Bearer {access_token}"
```

```python
import http.client

conn = http.client.HTTPSConnection("")

payload = "grant_type=client_credentials&scope={scope}"

headers = { 
  'Authorization': 'Basic {}'.format(base64.b64encode(bytes(f"{clientId}:{clientSecret}","utf-8")).decode("ascii"))
  'content-type': "application/x-www-form-urlencoded" 
}

conn.request("POST", "https://ala-test.auth.ap-southeast-2.amazoncognito.com/oauth2/token", payload, headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
```

>

The Client Credentials grant type is used for machine to machine authentication where there is no user interaction.

`POST <%= I18n.t(:authBaseUrl) %>/cas/oidc/oidcAccessToken`

Header Parameters:

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
Authorization | Y | | base64 encoded `<clientId>:<clientSecret>`
Content-Type | Y | | `application/x-www-form-urlencoded`

Request Parameters:

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
grant_type | Y | | Set to `client_credentials`
scope | N | | A space separated list of scopes that have been approved for the API Authorization client. These scopes will be included in the Access Token that is returned.

## Authentication Code Flow

>
The postman http client supports the authorisation code flow. When configured the user will be prompted to authenticate prior to accessing a protected API enpoint.<br><br>
![](postman-authentication-code.png)

>

`GET <%= I18n.t(:authBaseUrl) %>/cas/oidc/oidcAuthorize`

Request Parameters:

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
response_type | Y | | Set to `code`
client_id | Y | | the client id
scope | N | | A space separated list of scopes that have been approved for the API Authorization client. These scopes will be included in the Access Token that is returned.
redirect_url | Y | | The URL where the authentication server redirects the browser after the user is authorised.
code_challenge_method | N | | Set to `S256` if using PKCE
code_challenge | N | | the code challenge

`POST <%= I18n.t(:authBaseUrl) %>/cas/oidc/oidcAccessToken`

Header Parameters:

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
Authorization | N | | base64 encoded `<clientId>:<clientSecret>`. Not required for authenticating public clients.
Content-Type | Y | | `application/x-www-form-urlencoded`

Request Parameters:

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
grant_type | Y | | Set to `authorization_code`
code | Y | | The authentication code returned from the authentication step
redirect_url | Y | | The URL where the authentication server redirects the browser after the user is authorised.
code_verifier | N | | the code challenge if using PKCE

## Implicit Flow

>
The postman http client supports the implicit authorisation flow. When configured the user will be prompted to authenticate prior to accessing a protected API enpoint.<br><br>
![](postman-implicit.png)

>

The Implicit Flow is used for apps that have no “back end” logic on the web server, like a Javascript app.

The Implicit flow presents an authorisation page that will prompt a user for credentials before redirecting to the supplied `redirect_url` with the access_token.

`GET <%= I18n.t(:authBaseUrl) %>/cas/oidc/oidcAuthorize`

Request Parameters:

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
response_type | Y | | Set to `token`
client_id | Y | | the client id
scope | N | | A space separated list of scopes that have been approved for the API Authorization client. These scopes will be included in the Access Token that is returned.
redirect_url | Y | | The URL where the authentication server redirects the browser after the user is authorised.

[Authentication Code Flow using PKCE](#authentication-code-flow) is recommended for authenticating public clients, as Implicit Authentication reveals the `accessToken` when the end-user is redirected back to the application, introducing a security risk.

# Products
<!--
## Species profile

Lookup by species (taxonomic name), including bulk species lookup, and downloads for both. You can also get a list of higher taxa for a requested taxon. 

## Occurrence  

Search and download occurrence records for specific groups, including a faceted search. There is also an option to ingest data. 

for full api documentation see [Open API specification](./openapi/index.html?urls.primaryName=biocache)

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

### Auto complete Search (occurrence based names)

#### HTTP Request
`GET <%= I18n.t(:autoCompleteBaseUrl) %>/autocomplete/search`

#### Query Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q	| Y | | Input query
fq | N | | Filter query that is used to determine occurrence counts
pageSize | N | 10	| Max number of results to return
all	| N | | Set this to true to include matches with 0 occurrences found
counts | N | | Set this to false to exclude occurrence counts
synonyms | N | | Set this to false to exclude synonym matches

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
-->
## 1. Alerts

Access alerts functions, including view alert details, unsubscribe from and create an alert.

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=alerts">Open API specification</a>
</aside>

## 1.1 GET api/alerts/user/{userId} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:alertsAPIUrl) %>/api/alerts/user/{1}' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
  "disabledQueries": [],
  "enabledQueries": [],
  "customQueries": [],
  "frequencies": [
    {
          "id": 1,
          "name": "hourly",
          "lastChecked": "2022-07-06T02:48:00Z",
          "periodInSeconds": 3600,
          "version": null
        }
    ],
     "user": {
       "id": 1,
       "notifications": [],
       "userId": "1",
       "locked": false,
       "frequency": {
         "id": 3
       },
       "unsubscribeToken": "",
       "email": ""
     }
}
```
Get User Alerts

#### HTTP Request
`GET <%= I18n.t(:alertsAPIUrl) %>/api/alerts/user/{userId}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
userId | Y | | The User Id

## 1.2 POST api/alerts/user/{userId}/unsubscribe <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:alertsAPIUrl) %>/api/alerts/user/{1}/unsubscribe' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
  "success": true
}
```
Unsubscribe User Alerts

#### HTTP Request
`POST <%= I18n.t(:alertsAPIUrl) %>/api/alerts/user/{userId}/unsubscribe`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
userId | Y | | The User Id

## 1.3 POST api/alerts/user/createAlerts <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:alertsAPIUrl) %>/api/alerts/user/createAlerts?userId=1&email=email%40com.au&firstName=firstName&lastName=lastName' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

[
  "Blogs and News"
]
```
Create User Alerts

#### HTTP Request
`POST <%= I18n.t(:alertsAPIUrl) %>/api/alerts/user/createAlerts`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
userId | Y | | The User Id
email | Y | | The User email
firstName | N | | The User firstName
lastName | N | | The User lastName

## 2. Biocollect

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=biocollect">Open API specification</a>
</aside>

## 2.1 GET ws/bioactivity/delete/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/delete/1' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "status": 0,
  "error": "string",
  "text": "string"
}
```
Delete an activity

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/delete/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Activity id

## 2.2 GET ws/bioactivity/model/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/model/1' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "activity": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "returnTo": "string",
  "site": {
    "extent": {
      "geometry": {
        "areaKmSq": 0,
        "coordinates": [
          0
        ],
        "centre": [
          0
        ],
        "type": "string"
      },
      "source": "string"
    },
    "lastUpdated": "string",
    "projects": [
      "string"
    ],
    "dateCreated": "string",
    "visibility": "string",
    "name": "string",
    "siteId": "string",
    "id": "string",
    "geoPoint": [
      0
    ],
    "isSciStarter": true,
    "status": "string"
  },
  "project": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "projectSite": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "speciesLists": [
    {}
  ],
  "themes": [
    {}
  ],
  "metaModel": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "outputModels": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "getpActivity": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "error": "string"
}
```
Get survey's data model

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/model/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Survey id or project activity id

## 2.3 GET ws/bioactivity/data/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/data/1' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "activity": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "site": {
    "extent": {
      "geometry": {
        "areaKmSq": 0,
        "coordinates": [
          0
        ],
        "centre": [
          0
        ],
        "type": "string"
      },
      "source": "string"
    },
    "lastUpdated": "string",
    "projects": [
      "string"
    ],
    "dateCreated": "string",
    "visibility": "string",
    "name": "string",
    "siteId": "string",
    "id": "string",
    "geoPoint": [
      0
    ],
    "isSciStarter": true,
    "status": "string"
  },
  "project": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "projectSite": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "speciesLists": [
    {}
  ],
  "themes": [
    {}
  ],
  "metaModel": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "outputModels": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "getpActivity": {
    "additionalProp1": {},
    "additionalProp2": {},
    "additionalProp3": {}
  },
  "projectActivityId": "string",
  "error": "string"
}
```
Get data for an activity

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/data/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Activity id

## 2.4 GET ws/bioactivity/map <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/map' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "total": 0,
  "activities": [
    {
      "activityId": "string",
      "projectActivityId": "string",
      "type": "string",
      "name": "string",
      "activityOwnerName": "string",
      "records": [
        {
          "commonName": "string",
          "multimedia": [
            {
              "rightsHolder": "string",
              "identifier": "string",
              "license": "string",
              "creator": "string",
              "imageId": "string",
              "rights": "string",
              "format": "string",
              "documentId": "string",
              "title": "string",
              "type": "string"
            }
          ],
          "individualCount": 0,
          "name": "string",
          "coordinates": [
            0
          ],
          "eventTime": "string",
          "guid": "string",
          "occurrenceID": "string",
          "eventDate": "string"
        }
      ],
      "projectName": "string",
      "projectId": "string",
      "sites": [
        {
          "extent": {
            "geometry": {
              "areaKmSq": 0,
              "coordinates": [
                0
              ],
              "centre": [
                0
              ],
              "type": "string"
            },
            "source": "string"
          },
          "lastUpdated": "string",
          "projects": [
            "string"
          ],
          "dateCreated": "string",
          "visibility": "string",
          "name": "string",
          "siteId": "string",
          "id": "string",
          "geoPoint": [
            0
          ],
          "isSciStarter": true,
          "status": "string"
        }
      ],
      "coordinates": [
        0
      ]
    }
  ]
}
```
Get sites associated with an activity

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/map`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
hub | N | | The hub context this request will be executed in
searchTerm | N | | Searches for terms in this parameter.
max | N | 10 | Maximum number of returned activities per page.
offset | N | 0 | Offset search result by this parameter
view | N | | Page on which activities will be rendered. Available values : myrecords, project, projectrecords, myprojectrecords, userprojectactivityrecords, allrecords
fq | N | | Restrict search results to these filter queries.
sort | N | lastUpdated | Sort by attribute
order | N | DESC | Order sort item by this parameter

## 2.5 GET ws/bioactivity/search <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/search' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "activities": [
    {
      "activityId": "string",
      "projectActivityId": "string",
      "type": "string",
      "status": "string",
      "lastUpdated": "string",
      "userId": "string",
      "siteId": "string",
      "name": "string",
      "activityOwnerName": "string",
      "embargoed": true,
      "embargoUntil": "string",
      "records": [
        {
          "commonName": "string",
          "multimedia": [
            {
              "rightsHolder": "string",
              "identifier": "string",
              "license": "string",
              "creator": "string",
              "imageId": "string",
              "rights": "string",
              "format": "string",
              "documentId": "string",
              "title": "string",
              "type": "string"
            }
          ],
          "individualCount": 0,
          "name": "string",
          "coordinates": [
            0
          ],
          "eventTime": "string",
          "guid": "string",
          "occurrenceID": "string",
          "eventDate": "string"
        }
      ],
      "endDate": "string",
      "projectName": "string",
      "projectType": "string",
      "projectId": "string",
      "thumbnailUrl": "string",
      "showCrud": true,
      "userCanModerate": true
    }
  ],
  "facets": [
    {
      "name": "string",
      "total": 0,
      "terms": [
        {
          "additionalProp1": {},
          "additionalProp2": {},
          "additionalProp3": {}
        }
      ]
    }
  ],
  "total": 0
}
```
Search activities

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/bioactivity/search`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
hub | N | | The hub context this request will be executed in
searchTerm | N | | Searches for terms in this parameter.
max | N | 10 | Maximum number of returned activities per page.
offset | N | 0 | Offset search result by this parameter
view | N | | Page on which activities will be rendered. Available values : myrecords, project, projectrecords, myprojectrecords, userprojectactivityrecords, allrecords
fq | N | | Restrict search results to these filter queries.
sort | N | lastUpdated | Sort by attribute
order | N | DESC | Order sort item by this parameter
facets | N | | Comma seperated list of facets the search should return. If left empty, facet list is populated from hub configuration.
flimit | N | 20 | Maximum number of facets to be returned.

## 2.6 GET ws/species/uniqueId
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/species/uniqueId' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
  "outputSpeciesId": "4f28671f-0ec2-41dc-ab01-fd4cb2a5b0a6"
}
```
Get output species identifier

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/species/uniqueId`

## 2.7 GET ws/survey/list/{id}
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/survey/list/1' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
[
  "string"
]
```
Get surveys associated with a project

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/survey/list/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The project id

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
version | N | | The date and time in which project activity was created. Version number unit is milliseconds since epoch.

## 2.8 GET ws/project/search <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:biocollectAPIUrl) %>/ws/project/search' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "projects": [
    {
      "additionalProp1": {},
      "additionalProp2": {},
      "additionalProp3": {}
    }
  ],
  "total": 0,
  "facets": [
    {
      "name": "string",
      "total": 0,
      "terms": [
        {
          "additionalProp1": {},
          "additionalProp2": {},
          "additionalProp3": {}
        }
      ]
    }
  ]
}
```
Search projects

#### HTTP Request
`GET <%= I18n.t(:biocollectAPIUrl) %>/ws/project/search`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
hub | N | | The hub context this request will be executed in
q | N | | Searches for terms in this parameter.
max | N | 20 | Maximum number of returned activities per page.
offset | N | 0 | Offset search result by this parameter
status | N | | Return active or completed projects. Available values: active, completed
organisationName | N | | Filter projects by organisation name
geoSearchJSON | N | Filter projects by GeoJSON shape
isCitizenScience | N | false | Get citizen science projects
isWorks | N | false | Get works projects
isBiologicalScience | N | false | Get eco-science projects
difficulty | N | | Difficulty level of projects. Available values : Easy, Medium, Hard
isWorldWide | N | false | Set to false to return Australia specific projects. Set to true to get all projects.
isUserPage | N | false | Set to true to get all the projects a user is participating in.
mobile | N | false | Set to true if the request is coming from mobile client and user need to be identified. 
facets | N | | Comma seperated list of facets the search should return. If left empty, facet list is populated from hub configuration.
flimit | N | 15 | Maximum number of facets to be returned.

## 3. DOI service

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=doi">Open API specification</a>
</aside>

## 3.1 GET api/doi
```shell
curl -X 'GET' '<%= I18n.t(:doiAPIUrl) %>/api/doi?max=10&offset=0&sort=dateMinted&order=asc&userId=1&activeStatus=all' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

[
  {
    "id": 0,
    "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "doi": "string",
    "title": "string",
    "authors": "string",
    "userId": "string",
    "authorisedRoles": [
      "string"
    ],
    "licence": [
      "string"
    ],
    "description": "string",
    "dateMinted": "2022-07-14T05:36:23.716Z",
    "provider": "ANDS",
    "filename": "string",
    "contentType": "string",
    "fileHash": [
      "string"
    ],
    "fileSize": 0,
    "providerMetadata": {
      "additionalProp1": {},
      "additionalProp2": {},
      "additionalProp3": {}
    },
    "applicationMetadata": {
      "additionalProp1": {},
      "additionalProp2": {},
      "additionalProp3": {}
    },
    "customLandingPageUrl": "string",
    "applicationUrl": "string",
    "active": true,
    "dateCreated": "2022-07-14T05:36:23.716Z",
    "lastUpdated": "2022-07-14T05:36:23.716Z",
    "displayTemplate": "string"
  }
]

```
List DOIs

#### HTTP Request
`GET <%= I18n.t(:doiAPIUrl) %>/api/doi`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
max | N | 10 | The max number of dois to return
offset | N | 0 | The index of the first record to return
sort | N | dateMinted | The field to sort the results by. Valid values are 'dateMinted', 'dateCreated', 'lastUpdated', 'title'
order | N | desc | The direction to sort the results by. Valid values are 'asc', 'desc'
userId | N | | Add a userid filter, userid should be the user's numeric user id
activeStatus | N | active | Filters DOIs returned based on active flag. Valid values are 'all', 'active' or 'inactive'

## 3.2 GET api/doi/{id}
```shell
curl -X 'GET' '<%= I18n.t(:doiAPIUrl) %>/api/doi/1' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
    "id": 866,
    "fileSize": 73585,
    "dateCreated": "2022-08-18T11:03:36Z",
    "providerMetadata": {
        "title": "test",
        "authors": [
            "test"
        ],
        "subjects": [
            "test"
        ],
        "subtitle": "test",
        "publisher": "test",
        "createdDate": "YYYY-MM-ddThh:mm:ssZ",
        "contributors": [
            {
                "name": "test",
                "type": "Editor"
            }
        ],
        "descriptions": [
            {
                "text": "test",
                "type": "Other"
            }
        ],
        "resourceText": "etc",
        "resourceType": "Text",
        "publicationYear": 2020.0
    },
    "customLandingPageUrl": null,
    "dateMinted": "2022-08-18T11:03:30Z",
    "uuid": "489c109c-76df-4129-b5c7-4a3327568231",
    "lastUpdated": "2022-08-29T22:39:02Z",
    "active": true,
    "doi": "10.80416/TEST_DOI_62fd8fe571828",
    "applicationMetadata": null,
    "provider": "ANDS",
    "title": "test",
    "applicationUrl": "https://collections-test.ala.org.au",
    "fileHash": [
        103
    ],
    "filename": "ala.25484e41-62a0-4819-be71-49a9ac4c51fd",
    "contentType": "text/html;charset=UTF-8",
    "authors": "test,xyz",
    "licence": [
        "cc by"
    ],
    "description": "test"
}
```
Get a stored DOI and its metadata

#### HTTP Request
`GET <%= I18n.t(:doiAPIUrl) %>/api/doi/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Either the DOI (encoded or unencoded) or the UUID

## 3.3 GET api/doi/search
```shell
curl -X 'GET' '<%= I18n.t(:doiAPIUrl) %>/api/doi/search?q=q&max=10&offset=0&sort=dateMinted&order=asc' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
    "aggregations": {},
    "highlight": [],
    "scores": {},
    "searchResults": [
        {
            "id": 1,
            "fileSize": 9315,
            "dateCreated": "2020-09-16T15:36:02Z",
            "providerMetadata": {
                "title": "test",
                "authors": [
                    "Atlas Of Living Australia"
                ],
                "creator": [
                    {
                        "name": "test",
                        "type": "Producer"
                    }
                ],
                "publisher": "Atlas Of Living Australia",
                "contributors": [
                    {
                        "name": "test",
                        "type": "Distributor"
                    }
                ],
                "descriptions": [
                    {
                        "text": "ALA occurrence record download",
                        "type": "Other"
                    }
                ],
                "resourceText": "Species information",
                "resourceType": "Text"
            },
            "customLandingPageUrl": null,
            "dateMinted": "2020-09-16T15:35:51Z",
            "uuid": "aa524247-24ec-4122-94ed-81986f93c577",
            "lastUpdated": "2020-09-16T15:36:04Z",
            "active": true,
            "doi": "10.80416/TEST_24ec-4122-94ed-81986f93c577",
            "applicationMetadata": {
                "lsid": "urn:lsid:biodiversity.org.au:afd.taxon:b07d25f7-59c3-461c-85f4-0c355353ac62",
                "name": "Beddomeia tasmanica",
                "datasets": [
                    {
                        "uid": "co198",
                        "name": "Tasmanian Museum and Art Gallery Invertebrate Collection",
                        "count": "2",
                        "licence": ""
                    }
                ],
                "modeller": "test",
                "searchUrl": "https://biocache-ws-test.ala.org.au/ws/occurrences/search?q=qid:1600234533143",
                "queryTitle": "<span class='lsid' id='urn:lsid:biodiversity.org.au:afd.taxon:b07d25f7-59c3-461c-85f4-0c355353ac62'>SPECIES: Beddomeia tasmanica</span>",
                "commonNames": "Hydrobiid Snail (Terrys Creek)",
                "recordCount": "51",
                "requestedOn": "Wed Sep 16 15:35:33 AEST 2020",
                "workflowUrl": "https://nectar-spatial-test.ala.org.au/ws/workflow/show/80",
                "organisation": "DPIPWE",
                "qualityFilters": [],
                "scientificName": "Beddomeia tasmanica",
                "applicationName": "CSDM",
                "dataSetAnnotation": "Beddomeia tasmanica points for testing",
                "workflowAnnotation": ""
            },
            "provider": "DATACITE",
            "title": "Occurrence download Beddomeia_tasmanica__Current_extent_",
            "applicationUrl": "https://biocache-ws-test.ala.org.au/ws/occurrences/search?q=qid:1600234533143",
            "fileHash": [
                -40
            ],
            "filename": "Beddomeia_tasmanica__Current_extent_.zip",
            "contentType": "multipart/form-data",
            "authors": "Atlas Of Living Australia",
            "licence": [
                "CC-BY",
                "Creative Commons Attribution (Australia) (CC-BY 3.0 (Au))"
            ],
            "description": "ALA occurrence record download"
        }
    ],
    "sort": {
        "1": [
            1600234551000
        ]8
    },
    "total": 865,
    "totalRel": "EQUAL_TO"
}

```
Search DOIs

#### HTTP Request
`GET <%= I18n.t(:doiAPIUrl) %>/api/doi/search`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q | N | | An elasticsearch Simple Query String formatted string
max | N | 10 | The max number of dois to return
offset | N | 0 | The index of the first record to return
sort | N | dateMinted | The field to sort the results by. Valid values are 'dateMinted', 'dateCreated', 'lastUpdated', 'title'
order | N | desc | The direction to sort the results by. Valid values are 'asc', 'desc'
fq | N | | filters the search results by by supplied fields
activeStatus | N | active | Filters DOIs returned based on active flag. Valid values are 'all', 'active' or 'inactive'

## 3.4 GET api/doi/{id}/download
```shell
curl -X 'GET' '<%= I18n.t(:doiAPIUrl) %>/api/doi/1/download' \
  -H 'accept: application/octet-stream'
```
Download the file associated with a DOI

#### HTTP Request
`GET <%= I18n.t(:doiAPIUrl) %>/api/doi/{id}/download`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Either the DOI (encoded or unencoded) or the UUID

## 3.5 POST api/doi <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:doiAPIUrl) %>/api/doi' \
  -H 'accept: application/json' -H 'content-type: application/json' -d 
'{
    "provider":"ANDS",
    "title":"test",
    "authors":"test",
    "description":"test",
    "licence":["cc by"],
    "applicationUrl":"url",
    "fileUrl":"url",
    "applicationMetadata":null,
    "customLandingPageUrl":null,
    "userId":56544,
    "active":true,
    "authorisedRoles":[],
    "displayTemplate":null,
    "providerMetadata":{
    "authors" : [
        "test"
    ],
    "contributors" : [{
        "name" : "test",
        "type" : "Editor"
    }
    ],
    "title" : "test",
    "subjects" : [
        "test"
    ],
    "subtitle" : "test",
    "publicationYear" : 2020,
    "createdDate" : "YYYY-MM-ddThh:mm:ssZ",
    "descriptions" : [{
        "text" : "test",
        "type" : "Other"
    }
    ],
    "resourceText" : "etc",
    "resourceType" : "Text",
    "publisher" : "test"
    }
}'

The above command returns JSON structured like this:
{
    "doi":"10.80416/TEST_DOI_630d3d19a0893",
    "doiServiceLandingPage":"url",
    "error":null,"landingPage":"url",
    "status":"ok",
    "uuid":"1"
}
```
Mint / Register / Reserve a DOI. Required scopes: 'doi/write'.

#### HTTP Request
`POST <%= I18n.t(:doiAPIUrl) %>/api/doi`

## 3.6 POST api/doi/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:doiAPIUrl) %>/api/doi/1' \
  -H 'accept: application/json' -H 'content-type: application/json' -d 
'{
    "authors" : [
        "test"
    ]
}'

The above command returns JSON structured like this:
{
    "id": 866,
    "fileSize": 73585,
    "dateCreated": "2022-08-18T11:03:36Z",
    "providerMetadata": {
        "title": "test",
        "authors": [
            "test"
        ],
        "subjects": [
            "test"
        ],
        "subtitle": "test",
        "publisher": "test",
        "createdDate": "YYYY-MM-ddThh:mm:ssZ",
        "contributors": [
            {
                "name": "test",
                "type": "Editor"
            }
        ],
        "descriptions": [
            {
                "text": "test",
                "type": "Other"
            }
        ],
        "resourceText": "etc",
        "resourceType": "Text",
        "publicationYear": 2020.0
    },
    "customLandingPageUrl": null,
    "dateMinted": "2022-08-18T11:03:30Z",
    "uuid": "489c109c-76df-4129-b5c7-4a3327568231",
    "lastUpdated": "2022-08-29T22:39:02Z",
    "active": true,
    "doi": "10.80416/TEST_DOI_62fd8fe571828",
    "applicationMetadata": null,
    "provider": "ANDS",
    "title": "test",
    "applicationUrl": "https://collections-test.ala.org.au",
    "fileHash": [
        103
    ],
    "filename": "ala.25484e41-62a0-4819-be71-49a9ac4c51fd",
    "contentType": "text/html;charset=UTF-8",
    "authors": "test,xyz",
    "licence": [
        "cc by"
    ],
    "description": "test"
}
```
Update the stored metadata or add a file to a DOI. Required scopes: 'doi/write'.

#### HTTP Request
`POST <%= I18n.t(:doiAPIUrl) %>/api/doi/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Either the DOI (encoded or unencoded) or the UUID

## 3.7 PUT api/doi/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'PUT' '<%= I18n.t(:doiAPIUrl) %>/api/doi/1' \
  -H 'accept: application/json' -H 'content-type: application/json' -d 
'{
    "authors" : [
        "test"
    ]
}'

The above command returns JSON structured like this:
{
    "id": 866,
    "fileSize": 73585,
    "dateCreated": "2022-08-18T11:03:36Z",
    "providerMetadata": {
        "title": "test",
        "authors": [
            "test"
        ],
        "subjects": [
            "test"
        ],
        "subtitle": "test",
        "publisher": "test",
        "createdDate": "YYYY-MM-ddThh:mm:ssZ",
        "contributors": [
            {
                "name": "test",
                "type": "Editor"
            }
        ],
        "descriptions": [
            {
                "text": "test",
                "type": "Other"
            }
        ],
        "resourceText": "etc",
        "resourceType": "Text",
        "publicationYear": 2020.0
    },
    "customLandingPageUrl": null,
    "dateMinted": "2022-08-18T11:03:30Z",
    "uuid": "489c109c-76df-4129-b5c7-4a3327568231",
    "lastUpdated": "2022-08-29T22:39:02Z",
    "active": true,
    "doi": "10.80416/TEST_DOI_62fd8fe571828",
    "applicationMetadata": null,
    "provider": "ANDS",
    "title": "test",
    "applicationUrl": "https://collections-test.ala.org.au",
    "fileHash": [
        103
    ],
    "filename": "ala.25484e41-62a0-4819-be71-49a9ac4c51fd",
    "contentType": "text/html;charset=UTF-8",
    "authors": "test,xyz",
    "licence": [
        "cc by"
    ],
    "description": "test"
}
```
Update the stored metadata or add a file to a DOI. Required scopes: 'doi/write'.

#### HTTP Request
`PUT <%= I18n.t(:doiAPIUrl) %>/api/doi/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Either the DOI (encoded or unencoded) or the UUID

## 3.8 PATCH api/doi/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'PATCH' '<%= I18n.t(:doiAPIUrl) %>/api/doi/1' \
  -H 'accept: application/json' -H 'content-type: application/json' -d 
'{
    "authors" : [
        "test"
    ]
}'

The above command returns JSON structured like this:
{
    "id": 866,
    "fileSize": 73585,
    "dateCreated": "2022-08-18T11:03:36Z",
    "providerMetadata": {
        "title": "test",
        "authors": [
            "test"
        ],
        "subjects": [
            "test"
        ],
        "subtitle": "test",
        "publisher": "test",
        "createdDate": "YYYY-MM-ddThh:mm:ssZ",
        "contributors": [
            {
                "name": "test",
                "type": "Editor"
            }
        ],
        "descriptions": [
            {
                "text": "test",
                "type": "Other"
            }
        ],
        "resourceText": "etc",
        "resourceType": "Text",
        "publicationYear": 2020.0
    },
    "customLandingPageUrl": null,
    "dateMinted": "2022-08-18T11:03:30Z",
    "uuid": "489c109c-76df-4129-b5c7-4a3327568231",
    "lastUpdated": "2022-08-29T22:39:02Z",
    "active": true,
    "doi": "10.80416/TEST_DOI_62fd8fe571828",
    "applicationMetadata": null,
    "provider": "ANDS",
    "title": "test",
    "applicationUrl": "https://collections-test.ala.org.au",
    "fileHash": [
        103
    ],
    "filename": "ala.25484e41-62a0-4819-be71-49a9ac4c51fd",
    "contentType": "text/html;charset=UTF-8",
    "authors": "test,xyz",
    "licence": [
        "cc by"
    ],
    "description": "test"
}
```
Update the stored metadata or add a file to a DOI. Required scopes: 'doi/write'.

#### HTTP Request
`PATCH <%= I18n.t(:doiAPIUrl) %>/api/doi/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Either the DOI (encoded or unencoded) or the UUID

## 4. Logger service

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=logger">Open API specification</a>
</aside>

## 4.1 GET service/emailBreakdown
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/emailBreakdown?eventId=1002&entityUid=dp5142' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "last3Months": {
    "events": 0,
    "records": 0,
    "emailBreakdown": {
      "edu": {
        "events": 0,
        "records": 0
      }
    }
  },
  "all": {
    "events": 22,
    "records": 1007,
    "emailBreakdown": {
      "edu": {
        "events": 0,
        "records": 0
      }
    }
  },
  "thisMonth": {
    "events": 0,
    "records": 0,
    "emailBreakdown": {
      "edu": {
        "events": 0,
        "records": 0
      }
    }
  },
  "lastYear": {
    "events": 0,
    "records": 0,
    "emailBreakdown": {
      "edu": {
        "events": 0,
        "records": 0
      }
    }
  }
}
```
Get Email Breakdown

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/emailBreakdown`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
eventId | Y | | The event type Id
entityUid | Y | | The event Uid

## 4.2 GET service/logger/events
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/logger/events' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

[
  {
    "name": "OCCURRENCE_RECORDS_VIEWED",
    "id": 1000
  },
  {
    "name": "OCCURRENCE_RECORDS_VIEWED_ON_MAP",
    "id": 1001
  },
  {
    "name": "OCCURRENCE_RECORDS_DOWNLOADED",
    "id": 1002
  },
  {
    "name": "IMAGE_VIEWED",
    "id": 2000
  }
]
```
Get Event Types

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/logger/events`

## 4.3 GET service/reasonBreakdown
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/reasonBreakdown?eventId=1002&entityUid=dp5142' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "thisMonth": {
    "events": 0,
    "records": 0,
    "reasonBreakdown": {
      "biosecurity management/planning": {
        "events": 0,
        "records": 0
      }
    }
  },
  "last3Months": {
    "events": 0,
    "records": 0,
    "reasonBreakdown": {
      "biosecurity management/planning": {
        "events": 0,
        "records": 0
      }
    }
  },
  "lastYear": {
    "events": 0,
    "records": 0,
    "reasonBreakdown": {
      "biosecurity management/planning": {
        "events": 0,
        "records": 0
      }
    }
  },
  "all": {
    "events": 22,
    "records": 1007,
    "reasonBreakdown": {
      "biosecurity management/planning": {
        "events": 0,
        "records": 0
      }
    }
  }
}
```
Get Reason Breakdown

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/reasonBreakdown`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
eventId | Y | | The event type Id
entityUid | Y | | The event Uid

## 4.4 GET service/reasonBreakdownMonthly
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/reasonBreakdownMonthly?eventId=1002&entityUid=in21&reasonId=10&sourceId=4' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "temporalBreakdown": {
    "202205": {
      "records": 963,
      "events": 4
    }
  }
}
```
Get Reason Breakdown by Month

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/reasonBreakdownMonthly`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
eventId | Y | | The event type Id
entityUid | Y | | The event Uid
reasonId | N | | The reason Id of the event
sourceId | N | | The source id of the event
excludeReasonTypeId | N | | The reason id that needs to be excluded

## 4.5 GET service/logger/reasons
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/logger/reasons' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

[
  {
    "rkey": "logger.download.reason.biosecurity",
    "name": "biosecurity management/planning",
    "id": 1,
    "deprecated": false
  }
]
```
Get Reason Types

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/logger/reasons`

## 4.6 GET service/sourceBreakdown
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/sourceBreakdown?eventId=1002&entityUid=dp5142&excludeReasonTypeId=10' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "thisMonth": {
    "events": 0,
    "records": 0,
    "sourceBreakdown": {
      "ALA": {
        "events": 0,
        "records": 0
      }
    }
  },
  "last3Months": {
    "events": 0,
    "records": 0,
    "sourceBreakdown": {
      "ALA": {
        "events": 0,
        "records": 0
      }
    }
  },
  "lastYear": {
    "events": 0,
    "records": 0,
    "sourceBreakdown": {
      "ALA": {
        "events": 0,
        "records": 0
      }
    }
  },
  "all": {
    "events": 6,
    "records": 484,
    "sourceBreakdown": {
      "ALA": {
        "events": 1,
        "records": 10
      }
    }
  }
}
```
Get Source Breakdown

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/sourceBreakdown`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
eventId | Y | | The event type Id
entityUid | Y | | The event Uid
excludeReasonTypeId | N | | The reason id that needs to be excluded

## 4.7 GET service/logger/sources
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/logger/sources' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

[
  {
    "name": "ALA",
    "id": 0
  }
]
```
Get Source Types

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/logger/sources`

## 4.8 GET service/totalsByType
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/totalsByType' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "totals": {
    "1000": {
      "records": 1738,
      "events": 1649
    },
    "1002": {
      "records": 371641484,
      "events": 3533
    }
  }
}
```
Get Totals by Event Type

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/totalsByType`

## 4.9 GET service/logger/get.json
```shell
curl -X 'GET' '<%= I18n.t(:loggerAPIUrl) %>/service/logger/get.json?eventTypeId=1002&q=dp34&year=2020' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "months": [
    [
      "202002",
      13900
    ],
    [
      "202003",
      81766
    ],
    [
      "202004",
      1530
    ]
  ]
}
```
Get Monthly Breakdown by year

#### HTTP Request
`GET <%= I18n.t(:loggerAPIUrl) %>/service/logger/get.json`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
eventId | Y | | The event type Id
entityUid | Y | | The event Uid
year | N | | The event year

## 5. User details

Access the user details platform.


<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=userdetails">Open API specification</a>
</aside>

## 5.1 GET /ws/flickr
```shell
curl -X 'GET' '<%= I18n.t(:userdetailsAPIUrl) %>/ws/flickr' \
  -H 'accept: application/json'"

The above command returns JSON structured like this:

{
  "flickrUsers": [
    {
      "id": "21",
      "externalId": "externalId",
      "externalUsername": "externalUsername",
      "externalUrl": "http://www.flickr.com/photos/externalId"
    },
  ]
}
```
Lists all flickr profiles known to the application, including their ala id, flickr id, username and their flickr URL.

#### HTTP Request
`GET <%= I18n.t(:userdetailsAPIUrl) %>/ws/flickr`

## 5.2 GET /ws/getUserStats
```shell
curl -X 'GET' '<%= I18n.t(:userdetailsAPIUrl) %>/ws/getUserStats' -H 'accept: application/json'

The above command returns JSON structured like this:

{
   "description":"'totalUsers' count excludes locked and non-activated accounts. 'totalUsersOneYearAgo' count is calculated from the 'created' date being earlier than 1 year from today.",
   "totalUsers":36275,
   "totalUsersOneYearAgo":36245
}
```
Gets a count of all users in the system, including the number locked and activated. In addition it also provides a count of users from one year ago.

#### HTTP Request
`GET <%= I18n.t(:userdetailsAPIUrl) %>/ws/getUserStats`

## 5.3 GET /userDetails/byRole <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:userdetailsAPIUrl) %>/userDetails/byRole?role=ROLE_ADMIN' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

[
  {
    "userId": "13",
    "userName": "userName",
    "firstName": "firstName",
    "lastName": "lastName",
    "email": "email",
    "activated": true,
    "locked": false,
    "roles": [
      "ROLE_ADMIN"
    ]
  }
]
```
Get Users by Role.

#### HTTP Request
`GET <%= I18n.t(:userdetailsAPIUrl) %>/userDetails/byRole`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
role | Y | | The role to get users for
id | N | | A list of user ids or usernames to limit the results to
includeProps | N | | Whether to include additional user properties or not

## 5.4 POST /userDetails/getUserDetails <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:userdetailsAPIUrl) %>/userDetails/getUserDetails?userName=userName' \
  -H 'accept: application/json' -d '' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
  "userId": "1",
  "userName": "userName",
  "firstName": "firstName",
  "lastName": "lastName",
  "email": "email",
  "activated": true,
  "locked": false,
  "roles": [
    "ROLE_USER"
  ]
}
```
Get User Details.

#### HTTP Request
`POST <%= I18n.t(:userdetailsAPIUrl) %>/userDetails/getUserDetails`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
userName | Y | | The username of the user
includeProps | N | | Whether to include additional user properties or not

## 5.5 POST /userDetails/getUserDetailsFromIdList <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:userdetailsAPIUrl) %>/userDetails/getUserDetailsFromIdList' \
  -H 'accept: application/json' -H 'Content-Type: application/json' \
  -d '{ "includeProps": true, "userIds": [0, 1] }' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
  "users": {
    "1": {
      "userId": "1",
      "userName": "userName",
      "firstName": "firstName",
      "lastName": "lastName",
      "email": "email",
      "activated": true,
      "locked": false,
      "roles": [
        "ROLE_USER"
      ],
      "props": {
        "state": "ACT",
        "country": "AU",
        "organisation": "CSIRO",
        "city": "Wright",
        "affiliation": ""
      }
    }
  },
  "invalidIds": [
    0
  ],
  "success": true
}
```
Get a list of user details for a list of user ids.

#### HTTP Request
`POST <%= I18n.t(:userdetailsAPIUrl) %>/userDetails/getUserDetailsFromIdList`

## 5.6 GET /userDetails/search <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:userdetailsAPIUrl) %>/userDetails/search?q=userName' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

[
  {
    "userId": "1",
    "userName": "userName",
    "firstName": "firstName",
    "lastName": "lastName",
    "email": "email",
    "activated": true,
    "locked": false,
    "roles": [
      "ROLE_USER"
    ],
    "props": {
      "affiliation": "",
      "organisation": "CSIRO",
      "state": "ACT",
      "city": "Wright",
      "country": "AU"
    }
  }
]
```
Search for users by username, email or display name.

#### HTTP Request
`GET <%= I18n.t(:userdetailsAPIUrl) %>/userDetails/search`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q | Y | | Search query for the user's username, email or display name
max | N | | Maximum number of results to return

## 5.7 GET /property/getProperty <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:userdetailsAPIUrl) %>/property/getProperty?alaId=alaId&name=name' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

[
  {
    "property": "name",
    "value": "value"
  }
]
```
Get a property value for a user.

#### HTTP Request
`GET <%= I18n.t(:userdetailsAPIUrl) %>/property/getProperty`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
alaId | Y | | The user's ALA ID
name | Y | | The name of the property to get

## 5.8 POST /property/saveProperty <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:userdetailsAPIUrl) %>/property/saveProperty?alaId=alaId&name=name&value=value' \
  -H 'accept: application/json' -d '' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
  "property": "name",
  "value": "value"
}
```
Saves a property value for a user.

#### HTTP Request
`POST <%= I18n.t(:userdetailsAPIUrl) %>/property/saveProperty`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
alaId | Y | | The user's ALA ID
name | Y | | The name of the property to get
value | Y | | The value of the property to set

## 6. Biodiversity Information Explorer Service
<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=bie-index">Open API specification</a>
</aside>


## 6.1 GET /api/services/all <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:bieIndexAPIUrl) %>/api/services/all' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
    "id": "e68dd770-76fb-444e-a9c0-c8f2a29104c9",
    "active": true,
    "success": true,
    "completed": false,
    "lifecycle": "RUNNING",
    "title": "Import all information",
    "message": null,
    "lastUpdated": "2022-08-21T23:16:43Z"
}
```

Import all features via web service

#### HTTP Request
`GET <%= I18n.t(:bieIndexAPIUrl) %>/api/services/all`

## 6.2 GET /api/services/status/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:bieIndexAPIUrl) %>/api/services/status/{id}' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:

{
    "id": "112344",
    "active": true,
    "success": true,
    "completed": false,
    "lifecycle": "RUNNING",
    "title": "Import all information",
    "message": null,
    "lastUpdated": "2022-08-21T23:16:43Z"
}

```

Get status

#### HTTP Request
`GET <%= I18n.t(:bieIndexAPIUrl) %>/api/services/status/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The import job  Id

## 6.3 GET /search/auto.json 
```shell
curl -X 'GET' '<%= I18n.t(:bieIndexAPIUrl) %>/search/auto.json?q=fish' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  "autoCompleteList":
  [
    {
    "commonName":"Sword Ferns",
    "commonNameMatches":["<b>Fish<\/b>bone Ferns"],
    "georeferencedCount":0,
    "guid":"https://id.biodiversity.org.au/taxon/apni/51283259",
    "matchedNames":["Fishbone Ferns"],
    "name":"Nephrolepis",
    "occurrenceCount":0,
    "rankID":6000,
    "rankString":"genus",
    "scientificNameMatches":[]
    },
    {
      "commonName":"Unicorn Fish",
      "commonNameMatches":["Unicorn <b>Fish<\/b>"],
      "georeferencedCount":0,
      "guid":"https://biodiversity.org.au/afd/taxa/454ce794-b914-420d-9317-ed3a4133973a",
      "matchedNames":["Unicorn Fish"],
      "name":"Naso",
      "occurrenceCount":0,
      "rankID":6000,
      "rankString":"genus",
      "scientificNameMatches":[]
      }
  ]
}

```

Get results from JSON autocomplete

#### HTTP Request
`GET <%= I18n.t(:bieIndexAPIUrl) %>/search/auto.json`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q | Y | |The value to auto complete e.g. q=Fish
idxType | N | |The index type to limit. Values include: * TAXON * REGION * COLLECTION * INSTITUTION * DATASET
kingdom | N | |The higher-order taxonomic rank to limit the result
geoOnly | N | |(Not Implemented) Limit value to limit result with geospatial occurrence records
limit | N | |The maximum number of results to return (default = 10)


## 7. Species lists

Interact with species lists, including get list details and create a list.

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=specieslist">Open API specification</a>
</aside>

## 7.1 GET /ws/speciesList/{druid} 
```shell
curl -X 'GET' '<%= I18n.t(:specieslistIndexAPIUrl) %>/ws/speciesList/{druid}' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
  dataResourceUid: "dr123"
  dateCreated: "2021-03-08T22:37:58Z"
  fullName: null
  isAuthoritative: false
  isInvasive: false
  isThreatened: false
  itemCount: 59
  listName: "Example species name"
  listType: "TEST"
  username: "someone@example.com"
}
```

Get details of a specific species list  - as specified by the {druid}

#### HTTP Request
`GET <%= I18n.t(:specieslistIndexAPIUrl) %>/ws/speciesList/{druid}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
druid | Y | | the druid to query

## 7.2 POST /ws/speciesListPost <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:specieslistIndexAPIUrl) %>/ws/speciesListPost' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}" -H "X-ALA-userId : {ala_user_id}" \
  --data '{"exampleKey": "exampleKey"}' 

The above command returns JSON structured like this:

{
    "status": 200,
    "message": "added species list",
    "druid": "dr123",
    "data": [
        {
            "guid": "some value",
            "kvps": {
                "testKey": "testValue",
                "testKey2": "testValue2"
            }
        }
    ]
}
```

Save the provided list in the body to the lists application under the specified {ala_user_id}

#### HTTP Request
`GET <%= I18n.t(:specieslistIndexAPIUrl) %>/ws/speciesListPost`


## 7.3 POST /ws/listCommonKeys 
```shell
curl -X 'POST' '<%= I18n.t(:specieslistIndexAPIUrl) %>/ws/listCommonKeys?druid={druid}' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

["vernacular name"]
```

Get a list of keys from KVP common across multiple species lists

#### HTTP Request
`GET <%= I18n.t(:specieslistIndexAPIUrl) %>/ws/listCommonKeys`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
druid | Y | | A comma separated list of druids to query


## 8. Collectory (Museum and herbaria collections)

Services for interacting with attribution information, such as data provider metadata and citations.

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=collectory">Open API specification</a>
</aside>

## 8.1 POST /ws/contacts/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'POST' '<%= I18n.t(:collectoryApiUrl) %>/ws/contacts/616' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}" -H 'content-type: application/json' -d 
'{
    "title": "Mr",
    "firstName": "Test name",
    "lastName": "Test Surname",
    "email": "testemail @ala.org.au",
    "phone": null,
    "fax": null,
    "mobile": null,
    "publish": false 
}'

The above command returns JSON structured like this:
{
    "title": "Mr",
    "firstName": "Test name",
    "lastName": "Test Surname",
    "email": "testemail @ala.org.au",
    "phone": 12345,
    "fax": 1234556,
    "mobile": 1234566,
    "publish": false 
}
```
Update an existing contact with the specified contact id

### HTTP Request
`POST <%= I18n.t(:collectoryApiUrl) %>/ws/contacts/{id}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The contact identifier

## 8.2 GET /ws/contacts/{id} <p style="display: inline;">&#128274;</p>
```shell
curl -X 'GET' '<%= I18n.t(:collectoryApiUrl) %>/ws/contacts/616' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

The above command returns JSON structured like this:
{
  "id": "616",
  "title": "Mr",
  "firstName": "Test name",
  "lastName": "Test Surname",
  "email": "testemail @ala.org.au",
  "phone": 12345,
  "fax": 1234556,
  "mobile": 1234566,
  "publish": false 
  "dateCreated": "2022-09-01T00:35:29.558Z",
  "lastUpdated": "2022-09-01T00:35:29.558Z"
}
```
Get an existing contact with the specified contact id
### HTTP Request
`POST <%= I18n.t(:collectoryApiUrl) %>/ws/contacts/{id}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The contact identifier

## 8.3 GET /ws/eml/{id}
```shell
curl -X 'GET' '<%= I18n.t(:collectoryApiUrl) %>/ws/eml/in17' \
  -H 'accept: text/xml'

The above command returns JSON structured like this:


<?xml version="1.0" encoding="UTF-8"?><eml:eml xmlns:d="eml://ecoinformatics.org/dataset-2.1.0" xmlns:eml="eml://ecoinformatics.org/eml-2.1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dc="http://purl.org/dc/terms/" xsi:schemaLocation="eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/1.1/eml-gbif-profile.xsd" system="ALA-Registry" scope="system" xml:lang="en" eml="eml://ecoinformatics.org/eml-2.1.1" xsi="http://www.w3.org/2001/XMLSchema-instance" dc="http://purl.org/dc/terms/">
  <dataset>
    <alternateIdentifier>some-internal-identifier</alternateIdentifier>
    <alternateIdentifier>urn:lsid:biocol.org:col:someid</alternateIdentifier>
    <alternateIdentifier>https://collections-test.ala.org.au/public/show/in17</alternateIdentifier>
    <title xmlns:lang="en">Museum and Art Gallery of the Northern Territory</title>
    <creator>
      <organizationName>Museum and Art Gallery of the Northern Territory</organizationName>
      <address/>
    </creator>
    <metadataProvider>
      <organizationName>Museum and Art Gallery of the Northern Territory</organizationName>
      <address/>
    </metadataProvider>
    <associatedParty>
      <organizationName>Atlas of Living Australia</organizationName>
      <address>
        <deliveryPoint>CSIRO Ecosystems Services</deliveryPoint>
        <city>Canberra</city>
        <administrativeArea>ACT</administrativeArea>
        <postalCode>2601</postalCode>
        <country>Australia</country>
      </address>
      <electronicMailAddress>info@ala.org.au</electronicMailAddress>
      <role>distributor</role>
    </associatedParty>
    <associatedParty>
      <organizationName>Northern Territory Museum and Art Gallery provider for OZCAM</organizationName>
      <role>publisher</role>
    </associatedParty>
    <associatedParty>
      <organizationName>Database of Australasian Vertebrate Occurrences</organizationName>
      <role>publisher</role>
    </associatedParty>
    <associatedParty>
      <organizationName>Fossil Birds</organizationName>
      <role>publisher</role>
    </associatedParty>
    <associatedParty>
      <organizationName>Fossil Fish</organizationName>
      <role>publisher</role>
    </associatedParty>
    <pubDate>2017-01-31</pubDate>
    <language>English</language>
    <abstract>
      <para>The Museum and Art Gallery of the Northern Territory (MAGNT) is the Top End of Australia’s premier scientific, cultural and artistic institution. The MAGNT holds extensive collections covering Natural History, Archaeology, Aboriginal Art and Culture, Northern Territory History, Maritime History, South East Asian and Oceanic Art and the Visual Arts.</para>
    </abstract>
    <distribution>
      <online>
        <url function="information">https://collections-test.ala.org.au/public/show/in17</url>
      </online>
    </distribution>
    <contact>
      <organizationName>Atlas of Living Australia</organizationName>
      <address>
        <deliveryPoint>CSIRO Ecosystems Services</deliveryPoint>
        <city>Canberra</city>
        <administrativeArea>ACT</administrativeArea>
        <postalCode>2601</postalCode>
        <country>Australia</country>
      </address>
      <electronicMailAddress>info@ala.org.au</electronicMailAddress>
    </contact>
  </dataset>
  <additionalMetadata>
    <metadata>
      <gbif>
        <dateStamp>2017-01-31T12:52:12</dateStamp>
        <hierarchyLevel>dataset</hierarchyLevel>
        <resourceLogoUrl>https://collections-test.ala.org.au/data/institution/COMBINED+MAGNT+LOGO+200v3.png</resourceLogoUrl>
      </gbif>
    </metadata>
  </additionalMetadata>
</eml:eml>
```
Get a field by id. Includes all objects associated with the field.

### HTTP Request
`GET <%= I18n.t(:collectoryApiUrl) %>/ws/eml/{id}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The entity identifier

## 8.4 GET /ws/lookup/summary/{id}
```shell
curl -X 'GET' '<%= I18n.t(:collectoryApiUrl) %>/ws/lookup/summary/co139' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
  "acronym": "MAGNT",
  "collectionId": "someid",
  "collectionName": "Museum and Art Gallery of the Northern Territory Amphibian Collection",
  "collectionUid": "co139",
  "derivedCollCodes": [
    "Amphibian"
  ],
  "derivedInstCodes": [
    "MAGNT"
  ],
  "hubMembership": [
    {
      "uid": "someuid",
      "name": "Online Zoological Collections of Australian Museums"
    }
  ],
  "id": 140,
  "institutionId": "someid",
  "institutionLogoUrl": "https://collections-test.ala.org.au/data/institution/COMBINED MAGNT LOGO 200v3.png",
  "institutionName": "Museum and Art Gallery of the Northern Territory",
  "institutionUid": "someid",
  "lsid": null,
  "name": "Museum and Art Gallery of the Northern Territory Amphibian Collection",
  "relatedDataProviders": [],
  "relatedDataResources": [],
  "shortDescription": "The MAGNT amphibian collection, established in 1981, consists of about 8,000 databased specimens, the majority of which have been collected in the Northern Territory.\r",
  "taxonomyCoverageHints": [
    {
      "class": "amphibia"
    }
  ],
  "uid": "co139",
  "uri": "https://collections-test.ala.org.au/ws/collection/co139"
}
```
Get summary information for an entity
### HTTP Request
`POST <%= I18n.t(:collectoryApiUrl) %>/ws/lookup/summary/{id}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The entity identifier


## 8.5 POST /ws/citations 
```shell
curl -X 'POST' '<%= I18n.t(:collectoryApiUrl) %>/ws/citations' \
  -H 'accept: application/json' -H 'content-type: application/json' -d 
'[
  "dr654",
  "dr653"
]'

The above command returns JSON structured like this:

[
    {
        "name": "Tasmania : Conservation Status",
        "citation": "Records provided by Tasmania : Conservation Status, accessed through ALA website.",
        "rights": "other",
        "link": "For more information: https://collections-test.ala.org.au/public/show/dr654",
        "dataGeneralizations": "",
        "informationWithheld": "",
        "downloadLimit": "",
        "uid": "dr654",
        "DOI": ""
    },
    {
        "name": "South Australia : Conservation Status",
        "citation": "Records provided by South Australia : Conservation Status, accessed through ALA website.",
        "rights": "other",
        "link": "For more information: https://collections-test.ala.org.au/public/show/dr653",
        "dataGeneralizations": "",
        "informationWithheld": "",
        "downloadLimit": "",
        "uid": "dr653",
        "DOI": ""
    }
]
```
Get citations for a list of data resource UIDs

### HTTP Request
`POST <%= I18n.t(:collectoryApiUrl) %>/ws/citations`

## 8.6 GET /ws/{entity}/{uid}
```shell
curl -X 'GET' '<%= I18n.t(:collectoryApiUrl) %>/ws/collection/co139' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

{
    "name": "Museum and Art Gallery of the Northern Territory Amphibian Collection",
    "acronym": "MAGNT",
    "uid": "co139",
    "guid": null,
    "address": {
        "street": "19 Conacher Street",
        "city": "Bullocky Point, Darwin",
        "state": "Northern Territory",
        "postcode": "0801",
        "country": "Australia",
        "postBox": "GPO Box 4646, Darwin, NT 0801"
    },
    "phone": null,
    "email": null,
    "pubShortDescription": null,
    "pubDescription": "The MAGNT amphibian collection, established in 1981, consists of about 8,000 databased specimens, the majority of which have been collected in the Northern Territory.\r\n\r\nThe majority of the specimens have been fixed in 10% formalin prior to being transferred into 70% ethanol for long term storage. Recently, frozen and ethanol-fixed tissue samples have been kept for genetic studies.\r\n\r\nSpecimens can be lent to workers at other institutions upon application and the MAGNT also welcomes visiting researchers.",
    "techDescription": null,
    "focus": null,
    "latitude": -12.4373636113,
    "longitude": 130.8331492698,
    "state": "Northern Territory",
    "websiteUrl": "magnt.net.au",
    "alaPublicUrl": "https://collections-test.ala.org.au/public/show/co139",
    "imageRef": {
        "filename": "R24497b.jpg",
        "caption": "Magnificent Tree Frog: Litoria splendida",
        "copyright": "MAGNT",
        "attribution": null,
        "uri": "https://collections-test.ala.org.au/data/collection/R24497b.jpg"
    },
    "networkMembership": [
        {
            "name": "Council of Heads of Australian Faunal Collections",
            "acronym": "CHAFC",
            "logo": "https://collections-test.ala.org.au/data/network/CHAFC_sm.jpg"
        },
        {
            "name": "Council of Heads of Australian Entomological Collections",
            "acronym": "CHAEC",
            "logo": "https://collections-test.ala.org.au/data/network/chaec-logo.png"
        },
        "did not match"
    ],
    "hubMembership": [
        {
            "uid": "dh1",
            "name": "Online Zoological Collections of Australian Museums",
            "uri": "https://collections-test.ala.org.au/ws/dataHub/dh1"
        }
    ],
    "taxonomyCoverageHints": [
        {
            "class": "amphibia"
        }
    ],
    "attributions": [],
    "dateCreated": "2010-09-06T03:45:01Z",
    "lastUpdated": "2021-11-27T08:01:57Z",
    "userLastModified": "not available",
    "collectionType": [
        "preserved",
        "taxonomic",
        "tissue"
    ],
    "keywords": [
        "frogs",
        "amphibians",
        "fauna",
        "microbes",
        "entomology",
        "plants"
    ],
    "active": "Active growth",
    "numRecords": 8000,
    "numRecordsDigitised": 8000,
    "states": null,
    "geographicDescription": "Mostly from the Northern Territory with some material from northern Western Australia and Queensland.",
    "startDate": "1981",
    "endDate": null,
    "kingdomCoverage": [
        "Animalia"
    ],
    "scientificNames": null,
    "subCollections": [],
    "institution": {
        "name": "Museum and Art Gallery of the Northern Territory",
        "uri": "https://collections-test.ala.org.au/ws/institution/in17",
        "uid": "in17"
    },
    "recordsProviderMapping": {
        "collectionCodes": [
            "Amphibian"
        ],
        "institutionCodes": [
            "MAGNT"
        ],
        "matchAnyCollectionCode": false,
        "exact": true,
        "warning": null,
        "dateCreated": "2010-09-06T07:58:02Z",
        "lastUpdated": "2015-01-29T04:11:29Z"
    },
    "gbifRegistryKey": null
}
```
Get a summary of entities that exist for a data type or detailed information for a specific entity.
### HTTP Request
`GET <%= I18n.t(:collectoryApiUrl) %>/ws/{entity}/{uid}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
entity | Y | | The entity name e.g. collection, dataProvider, institution
uid | N | | The entity uid 

## 8.7 POST /ws/{entity}/{uid}
```shell
curl -X 'POST' '<%= I18n.t(:collectoryApiUrl) %>/ws/dataProvider/dp5249' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}" -d 
  '{
    "name": "Test Data Provider 23",
    "acronym": null,
    "uid": "dp5249",
    "guid": null,
    "address": null,
    "phone": null,
    "email": null,
    "pubShortDescription": null,
    "pubDescription": null,
    "techDescription": null,
    "focus": null,
    "latitude": null,
    "longitude": null,
    "state": null,
    "websiteUrl": null,
    "alaPublicUrl": "https://collections-test.ala.org.au/public/show/dp5249",
    "networkMembership": null,
    "attributions": [],
    "dataResources": [],
    "gbifRegistryKey": null
    }
  '

The above command returns JSON structured like this:
 'updated DataProvider'
 OR 
 'inserted entity'

```
Insert or update an entity - if uid is specified, entity must exist and is updated with the provided data
### HTTP Request
`POST <%= I18n.t(:collectoryApiUrl) %>/ws/{entity}/{uid}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
entity | Y | | The entity name e.g. collection, dataProvider, institution
uid | N | | The entity uid 


## 9. Image service
<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=image-service">Open API specification</a>
</aside>

## 9.1 GET ws/analytics
```shell
curl -X 'GET' '<%= I18n.t(:imagesApiUrl) %>/ws/analytics' \
  -H 'accept: application/json'
```
Get overall image usage for the system

### HTTP Request
`GET <%= I18n.t(:imagesApiUrl) %>/ws/analytics`

## 9.2 GET image/details
```shell
curl -X 'GET' '<%= I18n.t(:imagesApiUrl) %>/image/details?id=1' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
  "imageIdentifier": "1",
  "mimeType": "image/jpeg",
  "originalFileName": "abc.jpg",
  "sizeInBytes": 65629,
  "rights": "",
  "rightsHolder": "",
  "dateUploaded": "2022-05-23 10:47:02",
  "dateTaken": "2022-05-23 10:47:02",
  "imageUrl": "https://images.ala.org.au/1/original",
  "tileUrlPattern": "https://images.ala.org.au/1/tms/{z}/{x}/{y}.png",
  "mmPerPixel": "",
  "height": 480,
  "width": 640,
  "tileZoomLevels": 4,
  "description": "",
  "title": "",
  "type": "",
  "audience": "",
  "references": "",
  "publisher": "",
  "contributor": "",
  "created": "",
  "source": "",
  "creator": "",
  "license": "",
  "recognisedLicence": null,
  "dataResourceUid": "dr893",
  "occurrenceID": ""
}
```
Get original image.

### HTTP Request
`GET <%= I18n.t(:imagesApiUrl) %>/image/details?id={id}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | Image Id

#### Headers

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
Accept | Y | | Content type requested

## 9.3 GET ws/images/tag/{tagID}
```shell
curl -X 'GET' '<%= I18n.t(:imagesApiUrl) %>/ws/images/tag/1?max=100&offset=0' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
  "tagID": "1",
  "totalImageCount": 0,
  "images": []
}
```
Find images by tag id.

### HTTP Request
`GET <%= I18n.t(:imagesApiUrl) %>/ws/images/tag/{tagID}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
tagID | Y | | tag Id

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
max | N | 100 | max results to return
offset | N | 0 | offset for paging

## 9.4 GET ws/getMetadataKeys
```shell
curl -X 'GET' '<%= I18n.t(:imagesApiUrl) %>/ws/getMetadataKeys?source=Embedded' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
[
  "Accelerometer X",
  "Accelerometer Y",
  "Accelerometer Z",
  "Active D-Lighting",
  "Advanced Scene Mode",
  "AE Bracket Compensation"
]
```
Find images by tag id.

### HTTP Request
`GET <%= I18n.t(:imagesApiUrl) %>/ws/getMetadataKeys?source={source}`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
source | N | Embedded | source - valid values are - Embedded, UserDefined and SystemDefined

## 10. Data Quality Service
<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=data-quality-service">Open API specification</a>
</aside>

## 10.1 GET /api/v1/data-profiles
```shell
curl -X 'GET' '<%= I18n.t(:dqfServiceApiUrl) %>/api/v1/data-profiles' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
[
  {
    "id": 0,
    "name": "string",
    "shortName": "string",
    "description": "string",
    "contactName": "string",
    "contactEmail": "string",
    "enabled": true,
    "isDefault": true,
    "displayOrder": 0,
    "dateCreated": "2022-09-28T06:01:35.253Z",
    "lastUpdated": "2022-09-28T06:01:35.253Z",
    "categories": [
      {
        "id": 0,
        "enabled": true,
        "name": "string",
        "label": "string",
        "description": "string",
        "displayOrder": 0,
        "dateCreated": "2022-09-28T06:01:35.253Z",
        "lastUpdated": "2022-09-28T06:01:35.253Z",
        "qualityProfile": "string",
        "qualityFilters": [
          {
            "id": 0,
            "enabled": true,
            "description": "string",
            "filter": "string",
            "displayOrder": 0,
            "dateCreated": "2022-09-28T06:01:35.253Z",
            "lastUpdated": "2022-09-28T06:01:35.253Z",
            "qualityCategory": "string",
            "qualityCategoryId": {}
          }
        ],
        "qualityProfileId": {}
      }
    ]
  }
]
```
List all quality profiles

### HTTP Request
`GET <%= I18n.t(:dqfServiceApiUrl) %>/api/v1/data-profiles`

#### Query Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
max	| N | | Maximum results to return
offset | N | | Number to offset the results by
sort | N | 	| Propert to sort results by
order | N | 	| Direction to sort results by
enabled	| N | | Only return enabled profiles
name | N | | Search for profiles by name
shortName | N | | Search for profiles by short name

## 10.2 GET /api/v1/data-profiles/{id}
```shell
curl -X 'GET' '<%= I18n.t(:dqfServiceApiUrl) %>/api/v1/data-profiles/123' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
    "id": 0,
    "name": "string",
    "shortName": "string",
    "description": "string",
    "contactName": "string",
    "contactEmail": "string",
    "enabled": true,
    "isDefault": true,
    "displayOrder": 0,
    "dateCreated": "2022-09-28T06:01:35.253Z",
    "lastUpdated": "2022-09-28T06:01:35.253Z",
    "categories": [
      {
        "id": 0,
        "enabled": true,
        "name": "string",
        "label": "string",
        "description": "string",
        "displayOrder": 0,
        "dateCreated": "2022-09-28T06:01:35.253Z",
        "lastUpdated": "2022-09-28T06:01:35.253Z",
        "qualityProfile": "string",
        "qualityFilters": [
          {
            "id": 0,
            "enabled": true,
            "description": "string",
            "filter": "string",
            "displayOrder": 0,
            "dateCreated": "2022-09-28T06:01:35.253Z",
            "lastUpdated": "2022-09-28T06:01:35.253Z",
            "qualityCategory": "string",
            "qualityCategoryId": {}
          }
        ],
        "qualityProfileId": {}
      }
    ]
  }
```
Retrieve a single quality profile

### HTTP Request
`GET <%= I18n.t(:dqfServiceApiUrl) %>/api/v1/data-profiles/{id}`

#### Path Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id	| Y | | The id or short name for the quality profile or default for the default profile

## 10.3 GET /api/v1/quality/findAllEnabledCategories
```shell
curl -X 'GET' '<%= I18n.t(:dqfServiceApiUrl) %>/api/v1/quality/findAllEnabledCategories?profileName=AVH' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
  "id": 0,
  "enabled": true,
  "name": "string",
  "label": "string",
  "description": "string",
  "displayOrder": 0,
  "dateCreated": "2022-09-28T06:07:25.935Z",
  "lastUpdated": "2022-09-28T06:07:25.935Z",
  "qualityProfile": {
    "id": 0,
    "name": "string",
    "shortName": "string",
    "description": "string",
    "contactName": "string",
    "contactEmail": "string",
    "enabled": true,
    "isDefault": true,
    "displayOrder": 0,
    "dateCreated": "2022-09-28T06:07:25.935Z",
    "lastUpdated": "2022-09-28T06:07:25.935Z",
    "categories": [
      "string"
    ]
  },
  "qualityFilters": [
    {
      "id": 0,
      "enabled": true,
      "description": "string",
      "filter": "string",
      "displayOrder": 0,
      "dateCreated": "2022-09-28T06:07:25.935Z",
      "lastUpdated": "2022-09-28T06:07:25.935Z",
      "qualityCategory": "string",
      "qualityCategoryId": {}
    }
  ],
  "qualityProfileId": {}
}
```
Find All Enabled Categories for a profile

### HTTP Request
`GET <%= I18n.t(:dqfServiceApiUrl) %>/api/v1/quality/findAllEnabledCategories`

#### Query Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
profileName	| N | | Profile name

## 10.4 GET /api/v1/quality/getEnabledQualityFilters
```shell
curl -X 'GET' '<%= I18n.t(:dqfServiceApiUrl) %>/api/v1/quality/getEnabledQualityFilters?profileName=AVH' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
[
  "-spatiallyValid:\"false\"",
  "-coordinateUncertaintyInMeters:[10001 TO *]",
  "-userAssertions:50001",
  "-outlierLayerCount:[3 TO *]",
  "-year:[* TO 1700]",
  "-raw_identification_qualifier:[* TO *]",
  "-(establishment_means:MANAGED OR establishment_means:CULTIVATED OR establishment_means:CAPTIVE)",
  "-assertions:TAXON_MATCH_NONE",
  "-decimalLatitude:0",
  "-assertions:INVALID_SCIENTIFIC_NAME",
  "-userAssertions:50005",
  "-assertions:TAXON_HOMONYM",
  "-decimalLongitude:0",
  "-assertions:\"PRESUMED_SWAPPED_COORDINATE\"",
  "-assertions:UNKNOWN_KINGDOM",
  "-assertions:TAXON_SCOPE_MISMATCH",
  "-assertions:\"COORDINATES_CENTRE_OF_STATEPROVINCE\"",
  "-assertions:\"COORDINATES_CENTRE_OF_COUNTRY\""
]
```
Get Enabled Quality Filters for a profile

### HTTP Request
`GET <%= I18n.t(:dqfServiceApiUrl) %>/api/v1/quality/getEnabledQualityFilters`

#### Query Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
profileName	| N | | Profile name

## 10.5 GET /api/v1/data-profiles/{profileId}/categories
```shell
curl -X 'GET' '<%= I18n.t(:dqfServiceApiUrl) %>/api/v1/data-profiles/AVH/categories' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
[
  {
    "id": 0,
    "enabled": true,
    "name": "string",
    "label": "string",
    "description": "string",
    "displayOrder": 0,
    "dateCreated": "2022-09-28T06:13:59.669Z",
    "lastUpdated": "2022-09-28T06:13:59.669Z",
    "qualityProfile": {
      "id": 0,
      "name": "string",
      "shortName": "string",
      "description": "string",
      "contactName": "string",
      "contactEmail": "string",
      "enabled": true,
      "isDefault": true,
      "displayOrder": 0,
      "dateCreated": "2022-09-28T06:13:59.669Z",
      "lastUpdated": "2022-09-28T06:13:59.669Z",
      "categories": [
        "string"
      ]
    },
    "qualityFilters": [
      {
        "id": 0,
        "enabled": true,
        "description": "string",
        "filter": "string",
        "displayOrder": 0,
        "dateCreated": "2022-09-28T06:13:59.669Z",
        "lastUpdated": "2022-09-28T06:13:59.669Z",
        "qualityCategory": "string",
        "qualityCategoryId": {}
      }
    ],
    "qualityProfileId": {}
  }
]
```
List all quality categories for a profile

### HTTP Request
`GET <%= I18n.t(:dqfServiceApiUrl) %>/api/v1/data-profiles/{profileId}/categories`

#### Path Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
profileId	| Y | | The id or short name for the quality profile or default for the default profile
#### Query Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
max	| N | | Max resunts to return

## 11. Profiles service
<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=profiles">Open API specification</a>
</aside>

## 12. Biocache Service
<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=biocache-service">Open API specification</a>
</aside>

## 12.1 GET /occurrences/search
```shell
curl -X 'GET' '<%= I18n.t(:biocacheServiceApiUrl) %>/occurrences/search?q=taxa%3A%22Kangaroo%22&qualityProfile=ALA&fq=state%3A%22New%20South%20Wales%22&fq=taxon_name%3A%22Macropus%20giganteus%22&pageSize=2' \
    -H 'accept: application/json'

The above command returns JSON structured like this:
{
    "pageSize": 1,
    "startIndex": 0,
    "totalRecords": 106861,
    "sort": "score",
    "dir": "asc",
    "status": "OK",
    "occurrences": [
        {
            "uuid": "9240eb81-714f-46ef-a3eb-2a06ad77d751",
            "occurrenceID": "03eaf726-a2b3-4e36-81d8-7f022dc692e8",
            "raw_institutionCode": "Atlas of Living Australia",
            "taxonConceptID": "https://biodiversity.org.au/afd/taxa/23f4784e-1116-482c-8e3e-b6b12733f588",
            "eventDate": 1528872650000,
            "scientificName": "Macropus giganteus",
            "vernacularName": "Eastern Grey Kangaroo",
            "taxonRank": "species",
            "taxonRankID": 7000,
            "country": "Australia",
            "kingdom": "Animalia",
            "phylum": "Chordata",
            "classs": "Mammalia",
            "order": "Diprotodontia",
            "family": "Macropodidae",
            "genus": "Macropus",
            "genusGuid": "https://biodiversity.org.au/afd/taxa/b1d9bf29-648f-47e6-8544-2c2fbdf632b1",
            "species": "Macropus giganteus",
            "speciesGuid": "https://biodiversity.org.au/afd/taxa/23f4784e-1116-482c-8e3e-b6b12733f588",
            "stateProvince": "New South Wales",
            "decimalLatitude": -31.291167,
            "decimalLongitude": 149.044991,
            "year": 2018,
            "month": "06",
            "basisOfRecord": "HUMAN_OBSERVATION",
            "raw_locationRemarks": "nullnull",
            "dataProviderUid": "dp31",
            "dataProviderName": "Citizen Science - ALA Website",
            "dataResourceUid": "dr364",
            "dataResourceName": "Test - Atlas Species sightings and OzAtlas - Update Testing",
            "assertions": [
                "MISSING_TAXONRANK",
                "COORDINATE_ROUNDED",
                "COUNTRY_DERIVED_FROM_COORDINATES",
                "GEODETIC_DATUM_ASSUMED_WGS84",
                "MISSING_GEODETICDATUM",
                "COORDINATE_UNCERTAINTY_METERS_INVALID",
                "MISSING_GEOREFERENCE_DATE",
                "MISSING_GEOREFERENCEDBY",
                "MISSING_GEOREFERENCEPROTOCOL",
                "MISSING_GEOREFERENCESOURCES",
                "MISSING_GEOREFERENCEVERIFICATIONSTATUS"
            ],
            "speciesGroups": [
                "Animals",
                "Mammals"
            ],
            "image": "4dbde5eb-5c2c-4304-aff1-5d756345e449",
            "images": [
                "4dbde5eb-5c2c-4304-aff1-5d756345e449"
            ],
            "spatiallyValid": true,
            "recordedBy": [
                "Hains, Michael"
            ],
            "collectors": [
                "Hains, Michael"
            ],
            "raw_scientificName": "Macropus giganteus",
            "raw_basisOfRecord": "HumanObservation",
            "multimedia": [
                "Image"
            ],
            "license": "CC-BY-NC 3.0 (Au)",
            "recordNumber": "https://biocollect.ala.org.au/sightings/bioActivity/index/3ac63185-be6d-49f8-abe7-37d7a28e6263",
            "imageUrl": "https://images-test.ala.org.au/image/proxyImage?imageId=4dbde5eb-5c2c-4304-aff1-5d756345e449",
            "largeImageUrl": "https://images-test.ala.org.au/image/proxyImageThumbnailLarge?imageId=4dbde5eb-5c2c-4304-aff1-5d756345e449",
            "smallImageUrl": "https://images-test.ala.org.au/image/proxyImageThumbnail?imageId=4dbde5eb-5c2c-4304-aff1-5d756345e449",
            "thumbnailUrl": "https://images-test.ala.org.au/image/proxyImageThumbnail?imageId=4dbde5eb-5c2c-4304-aff1-5d756345e449",
            "imageUrls": [
                "https://images-test.ala.org.au/image/proxyImageThumbnailLarge?imageId=4dbde5eb-5c2c-4304-aff1-5d756345e449"
            ],
            "geospatialKosher": "true",
            "latLong": "-31.291167,149.044991",
            "point1": "-31,149",
            "point01": "-31.3,149",
            "point001": "-31.29,149.04",
            "point0001": "-31.291,149.045",
            "point00001": "-31.2912,149.045",
            "collector": [
                "Hains, Michael"
            ],
            "namesLsid": "Macropus giganteus|https://biodiversity.org.au/afd/taxa/23f4784e-1116-482c-8e3e-b6b12733f588|Eastern Grey Kangaroo|Animalia|Macropodidae",
            "left": 68028,
            "right": 68028
        }
    ],
    "facetResults": [],
    "query": "?q=taxa%3A%22Kangaroo%22&qualityProfile=ALA&fq=state%3A%22New%20South%20Wales%22&fq=taxon_name%3A%22Macropus%20giganteus%22",
    "urlParameters": "?q=taxa%3A%22Kangaroo%22&qualityProfile=ALA&fq=state%3A%22New%20South%20Wales%22&fq=taxon_name%3A%22Macropus%20giganteus%22",
    "queryTitle": "text:Kangaroo",
    "activeFacetMap": {
        "taxon_name": {
            "name": "taxon_name",
            "displayName": "Scientific name:\"Macropus giganteus\"",
            "value": "\"Macropus giganteus\""
        },
        "state": {
            "name": "state",
            "displayName": "State/Territory:\"New South Wales\"",
            "value": "\"New South Wales\""
        }
    },
    "activeFacetObj": {
        "taxon_name": [
            {
                "name": "taxon_name",
                "displayName": "Scientific name:\"Macropus giganteus\"",
                "value": "taxon_name:\"Macropus giganteus\""
            }
        ],
        "state": [
            {
                "name": "state",
                "displayName": "State/Territory:\"New South Wales\"",
                "value": "state:\"New South Wales\""
            }
        ]
    }
} 
```

Occurrence search service that supports facets
### HTTP Request
`GET <%= I18n.t(:biocacheServiceApiUrl) %>/occurrences/search`

#### Query Parameters
Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q	| N | | Main search query. Examples 'q=Kangaroo' or 'q=vernacularName:red'
fq	| N | | Filter queries. Examples 'fq=state:Victoria&fq=state:Queensland
fl	| N | | Fields to return in the search response. Optional
facets	| N | | The facets to be included by the search
flimit	| N | | The limit for the number of facet values to return
fsort	| N | | The sort order in which to return the facets.  Either 'count' or 'index'
foffset	| N | | The offset of facets to return.  Used in conjunction to flimit
fprefix	| N | | The prefix to limit facet values
start	| N | | Paging start index
pageSize	| N | | The prefix to limit facet values
sort	| N | | The sort field to use
dir	| N | | Direction of sort
includeMultivalues	| N | | Include multi values
qc	| N | | The query context to be used for the search. This will be used to generate extra query filters.
facet	| N | | Enable/disable facets
qualityProfile	| N | | The quality profile to use, null for default
disableQualityFilter	| N | | Disable all default filters
radius	| N | | Default filters to disable (currently can only disable on category, so it's a list of disabled category name)
lat	| N | | Radius for a spatial search
lon	| N | | Decimal latitude for the spatial search
wkt	| N | | Decimal longitude for the spatial search
im	| N | | Well Known Text for the spatial search

## 12.2 GET /occurrences/{recordUuid}
```shell
curl -X 'GET' '<%= I18n.t(:biocacheServiceApiUrl) %>/occurrences/b64d9989-139d-4c80-83e5-0c2b2c88a429' \
    -H 'accept: application/json'
The above command returns JSON structured like this:
{
    "raw": {
        "rowKey": "b64d9989-139d-4c80-83e5-0c2b2c88a429",
        "uuid": "b64d9989-139d-4c80-83e5-0c2b2c88a429",
        "occurrence": {
            "catalogNumber": "SS9602-AG2-0017",
            "occurrenceStatus": "present",
            "basisOfRecord": "PreservedSpecimen",
            "modified": "2020-06-26T17:25:01",
            "organismQuantity": "149.24",
            "occurrenceID": "SS9602-AG2-0017",
            "organismQuantityType": "abundance?"
        },
        "classification": {
            "scientificName": "Fish eggs"
        },
        "location": {
            "country": "Australia",
            "decimalLatitude": "-36.36167",
            "terrestrial": true,
            "maximumDepthInMeters": "46",
            "locality": "AG2",
            "decimalLongitude": "150.16333",
            "coordinateUncertaintyInMeters": "200",
            "marine": false,
            "minimumDepthInMeters": "46",
            "footprintWKT": "POINT (150.16333 -36.36167)",
            "coordinatePrecision": "0.00179"
        },
        "event": {
            "eventID": "SS9602-AG2",
            "eventDate": "1996-04-16"
        },
        "attribution": {
            "dataResourceUid": "dr15899"
        },
        "identification": {},
        "measurement": {},
        "assertions": [
            "MISSING_TAXONRANK",
            "TAXON_MATCH_HIGHERRANK",
            "GEODETIC_DATUM_ASSUMED_WGS84",
            "MISSING_GEODETICDATUM",
            "MISSING_GEOREFERENCE_DATE",
            "MISSING_GEOREFERENCEDBY",
            "MISSING_GEOREFERENCEPROTOCOL",
            "MISSING_GEOREFERENCESOURCES",
            "MISSING_GEOREFERENCEVERIFICATIONSTATUS"
        ],
        "miscProperties": {},
        "queryAssertions": {},
        "defaultValuesUsed": false,
        "spatiallyValid": true,
        "geospatiallyKosher": true,
        "taxonomicallyKosher": "",
        "deleted": false,
        "firstLoaded": "2022-07-18T08:35:00.180Z",
        "dateDeleted": "",
        "lastModifiedTime": "2022-07-18T07:53:31.012Z"
    },
    "processed": {
        "rowKey": "b64d9989-139d-4c80-83e5-0c2b2c88a429",
        "uuid": "b64d9989-139d-4c80-83e5-0c2b2c88a429",
        "occurrence": {
            "occurrenceStatus": "PRESENT",
            "basisOfRecord": "PRESERVED_SPECIMEN",
            "modified": "2020-06-26T17:25:01",
            "organismQuantity": "149.24",
            "organismQuantityType": "abundance?"
        },
        "classification": {
            "scientificName": "Fish",
            "matchType": "higherMatch",
            "familyID": "ALA_DR654_29_1",
            "taxonConceptID": "ALA_DR654_29_1",
            "taxonRankID": 5000,
            "left": 38993,
            "taxonRank": "family",
            "nameType": "SCIENTIFIC",
            "right": 38993,
            "kingdom": "Animalia",
            "family": "Fish",
            "kingdomID": "https://biodiversity.org.au/afd/taxa/4647863b-760d-4b59-aaa1-502c8cdf8d3c"
        },
        "location": {
            "country": "Australia",
            "decimalLatitude": -36.36167,
            "terrestrial": true,
            "maximumDepthInMeters": "46.0",
            "locality": "AG2",
            "decimalLongitude": 150.16333,
            "stateProvince": "New South Wales",
            "biome": "TERRESTRIAL",
            "coordinateUncertaintyInMeters": 200.0,
            "marine": false,
            "minimumDepthInMeters": "46.0",
            "countryCode": "AU",
            "geodeticDatum": "EPSG:4326",
            "coordinatePrecision": 0.00179
        },
        "event": {
            "year": 1996,
            "month": 4,
            "datePrecision": "DAY",
            "day": 16,
            "eventDate": "1996-04-16"
        },
        "attribution": {
            "dataResourceName": "Habitat and fisheries production in the south east fishery ecosystem - Zooplankton records from three Southern Surveyor voyages, shelf waters, South East Australia (1994-1996)",
            "license": "CC-BY",
            "dataProviderUid": "dp5183",
            "dataResourceUid": "dr15899",
            "dataProviderName": "Ocean Biodiversity Information System"
        },
        "identification": {},
        "measurement": {},
        "miscProperties": {},
        "queryAssertions": {},
        "geospatiallyKosher": true,
        "taxonomicallyKosher": "",
        "deleted": false,
        "dateDeleted": "",
        "lastModifiedTime": "2022-07-18T08:15:28.709Z",
        "el": {
            "el2042": 0.7305,
            "el1055": 0.012536366,
            "el2100": 18.13,
            "el2089": -0.68,
            "el1056": 0.019182956,
            "el2101": 15.16,
            "el2043": 0.2691,
            "el2044": 3.7412,
            "el2088": 0.71999997,
            "el2104": 5.3478,
            "el2126": 0.0,
            "el2102": 21.47,
            "el2103": 6.31,
            "el952": 2.85E-4,
            "el899": 1041.0,
            "el954": 0.77659273,
            "el898": 4327.0,
            "el955": 18.324427,
            "el957": 91.958336,
            "el2092": 6.0,
            "el2093": 0.4,
            "el2090": 2.0E-4,
            "el2091": -2.0E-4,
            "el2096": 35.399998,
            "el2097": 35.63,
            "el2094": 0.0050000004,
            "el2095": 35.52,
            "el2098": 0.22999999,
            "el2099": 0.42,
            "el2016": 2014.4324,
            "el2017": 2014.4324,
            "el2119": 6.0842037,
            "el947": 0.08729017,
            "el848": -53.0,
            "el948": 0.62262326,
            "el10978": 12.325
        },
        "cl": {
            "cl12080": "Marine Park",
            "cl21": "Southeast Shelf Transition",
            "cl110945": "Marine Park",
            "cl10957": "Batemans",
            "cl927": "New South Wales (including Coastal Waters)",
            "cl10930": "South East NSW",
            "cl2105": "81",
            "cl988": "Cape Howe",
            "cl966": "Batemans Shelf",
            "cl12078": "Marine Park",
            "cl111032": "Marine Park",
            "cl2086": "Wild woodlands",
            "cl1051": "Batemans",
            "cl1076": "Water",
            "cl2120": "South East NSW",
            "cl990": "Atlas of Life in the Coastal Wilderness",
            "cl2080": "Batemans",
            "cl930": "Territorial Sea",
            "cl10947": "South East NSW",
            "cl991": "Shelf",
            "cl10946": "South East NSW",
            "cl110957": "Marine Park",
            "cl10945": "Batemans",
            "cl916": "Southern Rivers",
            "cl2111": "South East NSW",
            "cl2078": "Batemans",
            "cl917": "South-east Australia",
            "cl11032": "Batemans",
            "cl2077": "4.00000000"
        }
    },
    "systemAssertions": {
        "missing": [
            {
                "name": "MISSING_GEODETICDATUM",
                "code": 1007,
                "description": "missing geodeticdatum",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedBy",
                    "georeferencedDate",
                    "georeferenceRemarks",
                    "georeferenceProtocol",
                    "georeferenceSources",
                    "georeferenceVerificationStatus",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_GEOREFERENCEDBY",
                "code": 1009,
                "description": "missing georeferencedby",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedBy",
                    "georeferencedDate",
                    "georeferenceRemarks",
                    "georeferenceProtocol",
                    "georeferenceSources",
                    "georeferenceVerificationStatus",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_GEOREFERENCEPROTOCOL",
                "code": 1010,
                "description": "missing georeferenceprotocol",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedBy",
                    "georeferencedDate",
                    "georeferenceRemarks",
                    "georeferenceProtocol",
                    "georeferenceSources",
                    "georeferenceVerificationStatus",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_GEOREFERENCESOURCES",
                "code": 1011,
                "description": "missing georeferencesources",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedBy",
                    "georeferencedDate",
                    "georeferenceRemarks",
                    "georeferenceProtocol",
                    "georeferenceSources",
                    "georeferenceVerificationStatus",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_GEOREFERENCEVERIFICATIONSTATUS",
                "code": 1012,
                "description": "missing georeferenceverificationstatus",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedBy",
                    "georeferencedDate",
                    "georeferenceRemarks",
                    "georeferenceProtocol",
                    "georeferenceSources",
                    "georeferenceVerificationStatus",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_GEOREFERENCE_DATE",
                "code": 1008,
                "description": "missing georeference date",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedBy",
                    "georeferencedDate",
                    "georeferenceRemarks",
                    "georeferenceProtocol",
                    "georeferenceSources",
                    "georeferenceVerificationStatus",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_TAXONRANK",
                "code": 1031,
                "description": "missing taxonrank",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            }
        ],
        "unchecked": [
            {
                "name": "UNRECOGNISED_COLLECTION_CODE",
                "code": 1039,
                "description": "unrecognised collection code",
                "category": "Error",
                "termsRequiredToTest": [
                    "collectionCode",
                    "collectionID",
                    "institutionCode",
                    "institutionID"
                ],
                "fatal": true
            },
            {
                "name": "UNRECOGNISED_INSTITUTION_CODE",
                "code": 1040,
                "description": "unrecognised institution code",
                "category": "Error",
                "termsRequiredToTest": [
                    "collectionCode",
                    "collectionID",
                    "institutionCode",
                    "institutionID"
                ],
                "fatal": true
            },
            {
                "name": "FOOTPRINT_SRS_INVALID",
                "code": 2013,
                "description": "footprint srs invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "footprintSRS"
                ],
                "fatal": false
            },
            {
                "name": "ELEVATION_UNLIKELY",
                "code": 2037,
                "description": "elevation unlikely",
                "category": "Warning",
                "termsRequiredToTest": [
                    "minimumElevationInMeters",
                    "maximumElevationInMeters"
                ],
                "fatal": false
            },
            {
                "name": "ELEVATION_MIN_MAX_SWAPPED",
                "code": 2038,
                "description": "elevation min max swapped",
                "category": "Warning",
                "termsRequiredToTest": [
                    "minimumElevationInMeters",
                    "maximumElevationInMeters"
                ],
                "fatal": false
            },
            {
                "name": "ELEVATION_NOT_METRIC",
                "code": 2039,
                "description": "elevation not metric",
                "category": "Warning",
                "termsRequiredToTest": [
                    "minimumElevationInMeters",
                    "maximumElevationInMeters"
                ],
                "fatal": false
            },
            {
                "name": "ELEVATION_NON_NUMERIC",
                "code": 2040,
                "description": "elevation non numeric",
                "category": "Warning",
                "termsRequiredToTest": [
                    "minimumElevationInMeters",
                    "maximumElevationInMeters"
                ],
                "fatal": false
            },
            {
                "name": "IDENTIFIED_DATE_UNLIKELY",
                "code": 2043,
                "description": "identified date unlikely",
                "category": "Warning",
                "termsRequiredToTest": [
                    "dateIdentified"
                ],
                "fatal": false
            },
            {
                "name": "IDENTIFIED_DATE_INVALID",
                "code": 2044,
                "description": "identified date invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "dateIdentified"
                ],
                "fatal": false
            },
            {
                "name": "TYPE_STATUS_INVALID",
                "code": 2046,
                "description": "type status invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "typeStatus"
                ],
                "fatal": false
            },
            {
                "name": "REFERENCES_URI_INVALID",
                "code": 2049,
                "description": "references uri invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "references"
                ],
                "fatal": false
            },
            {
                "name": "INDIVIDUAL_COUNT_INVALID",
                "code": 2051,
                "description": "individual count invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "individualCount"
                ],
                "fatal": false
            },
            {
                "name": "INDIVIDUAL_COUNT_CONFLICTS_WITH_OCCURRENCE_STATUS",
                "code": 2052,
                "description": "individual count conflicts with occurrence status",
                "category": "Warning",
                "termsRequiredToTest": [
                    "individualCount"
                ],
                "fatal": false
            },
            {
                "name": "GEOREFERENCED_DATE_UNLIKELY",
                "code": 2056,
                "description": "georeferenced date unlikely",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedDate"
                ],
                "fatal": false
            },
            {
                "name": "GEOREFERENCED_DATE_INVALID",
                "code": 2057,
                "description": "georeferenced date invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "georeferencedDate"
                ],
                "fatal": false
            },
            {
                "name": "AMBIGUOUS_INSTITUTION",
                "code": 2058,
                "description": "ambiguous institution",
                "category": "Warning",
                "termsRequiredToTest": [
                    "institutionCode",
                    "institutionID",
                    "ownerInstitutionCode"
                ],
                "fatal": false
            },
            {
                "name": "AMBIGUOUS_COLLECTION",
                "code": 2059,
                "description": "ambiguous collection",
                "category": "Warning",
                "termsRequiredToTest": [
                    "collectionCode",
                    "collectionID"
                ],
                "fatal": false
            },
            {
                "name": "INSTITUTION_MATCH_NONE",
                "code": 2060,
                "description": "institution match none",
                "category": "Warning",
                "termsRequiredToTest": [
                    "institutionCode",
                    "institutionID",
                    "ownerInstitutionCode"
                ],
                "fatal": false
            },
            {
                "name": "COLLECTION_MATCH_NONE",
                "code": 2061,
                "description": "collection match none",
                "category": "Warning",
                "termsRequiredToTest": [
                    "collectionCode",
                    "collectionID"
                ],
                "fatal": false
            },
            {
                "name": "INSTITUTION_MATCH_FUZZY",
                "code": 2062,
                "description": "institution match fuzzy",
                "category": "Warning",
                "termsRequiredToTest": [
                    "institutionCode",
                    "institutionID",
                    "ownerInstitutionCode"
                ],
                "fatal": false
            },
            {
                "name": "COLLECTION_MATCH_FUZZY",
                "code": 2063,
                "description": "collection match fuzzy",
                "category": "Warning",
                "termsRequiredToTest": [
                    "collectionCode",
                    "collectionID"
                ],
                "fatal": false
            },
            {
                "name": "INSTITUTION_COLLECTION_MISMATCH",
                "code": 2064,
                "description": "institution collection mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "institutionCode",
                    "institutionID",
                    "ownerInstitutionCode"
                ],
                "fatal": false
            },
            {
                "name": "POSSIBLY_ON_LOAN",
                "code": 2065,
                "description": "possibly on loan",
                "category": "Comment",
                "termsRequiredToTest": [
                    "institutionCode",
                    "institutionID",
                    "ownerInstitutionCode"
                ],
                "fatal": false
            },
            {
                "name": "DIFFERENT_OWNER_INSTITUTION",
                "code": 2066,
                "description": "different owner institution",
                "category": "Comment",
                "termsRequiredToTest": [
                    "institutionCode",
                    "institutionID",
                    "ownerInstitutionCode"
                ],
                "fatal": false
            }
        ],
        "warning": [
            {
                "name": "GEODETIC_DATUM_ASSUMED_WGS84",
                "code": 2005,
                "description": "geodetic datum assumed wgs84",
                "category": "Comment",
                "termsRequiredToTest": [
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_MATCH_HIGHERRANK",
                "code": 2030,
                "description": "taxon match higherrank",
                "category": "Warning",
                "termsRequiredToTest": [
                    "order",
                    "family",
                    "scientificNameAuthorship",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "genericName",
                    "kingdom",
                    "phylum",
                    "class",
                    "genus",
                    "scientificName"
                ],
                "fatal": false
            }
        ],
        "passed": [
            {
                "name": "BASIS_OF_RECORD_INVALID",
                "code": 2045,
                "description": "basis of record invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "basisOfRecord"
                ],
                "fatal": false
            },
            {
                "name": "CONTINENT_COUNTRY_MISMATCH",
                "code": 2020,
                "description": "continent country mismatch",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "CONTINENT_DERIVED_FROM_COORDINATES",
                "code": 2022,
                "description": "continent derived from coordinates",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "CONTINENT_INVALID",
                "code": 2021,
                "description": "continent invalid",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "COORDINATES_CENTRE_OF_COUNTRY",
                "code": 1006,
                "description": "coordinates centre of country",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "country",
                    "countryCode"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATES_CENTRE_OF_STATEPROVINCE",
                "code": 1001,
                "description": "coordinates centre of stateprovince",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_ACCURACY_INVALID",
                "code": 2009,
                "description": "coordinate accuracy invalid",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "COORDINATE_INVALID",
                "code": 2002,
                "description": "coordinate invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_OUT_OF_RANGE",
                "code": 2001,
                "description": "coordinate out of range",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_PRECISION_INVALID",
                "code": 2010,
                "description": "coordinate precision invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "coordinatePrecision"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_PRECISION_UNCERTAINTY_MISMATCH",
                "code": 2012,
                "description": "coordinate precision uncertainty mismatch",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "COORDINATE_REPROJECTED",
                "code": 2006,
                "description": "coordinate reprojected",
                "category": "Comment",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_REPROJECTION_FAILED",
                "code": 2007,
                "description": "coordinate reprojection failed",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_REPROJECTION_SUSPICIOUS",
                "code": 2008,
                "description": "coordinate reprojection suspicious",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_ROUNDED",
                "code": 2003,
                "description": "coordinate rounded",
                "category": "Comment",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "COORDINATE_UNCERTAINTY_METERS_INVALID",
                "code": 2011,
                "description": "coordinate uncertainty meters invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "coordinateUncertaintyInMeters"
                ],
                "fatal": false
            },
            {
                "name": "COUNTRY_COORDINATE_MISMATCH",
                "code": 2016,
                "description": "country coordinate mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "countryCode",
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "country"
                ],
                "fatal": false
            },
            {
                "name": "COUNTRY_DERIVED_FROM_COORDINATES",
                "code": 2019,
                "description": "country derived from coordinates",
                "category": "Warning",
                "termsRequiredToTest": [
                    "countryCode",
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "country"
                ],
                "fatal": false
            },
            {
                "name": "COUNTRY_INVALID",
                "code": 2018,
                "description": "country invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "countryCode",
                    "country"
                ],
                "fatal": false
            },
            {
                "name": "COUNTRY_MISMATCH",
                "code": 2017,
                "description": "country mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "countryCode",
                    "country"
                ],
                "fatal": false
            },
            {
                "name": "DEPTH_MIN_MAX_SWAPPED",
                "code": 2035,
                "description": "depth min max swapped",
                "category": "Warning",
                "termsRequiredToTest": [
                    "maximumDepthInMeters",
                    "minimumDepthInMeters"
                ],
                "fatal": false
            },
            {
                "name": "DEPTH_NON_NUMERIC",
                "code": 2036,
                "description": "depth non numeric",
                "category": "Warning",
                "termsRequiredToTest": [
                    "maximumDepthInMeters",
                    "minimumDepthInMeters"
                ],
                "fatal": false
            },
            {
                "name": "DEPTH_NOT_METRIC",
                "code": 2033,
                "description": "depth not metric",
                "category": "Warning",
                "termsRequiredToTest": [
                    "maximumDepthInMeters",
                    "minimumDepthInMeters"
                ],
                "fatal": false
            },
            {
                "name": "DEPTH_UNLIKELY",
                "code": 2034,
                "description": "depth unlikely",
                "category": "Warning",
                "termsRequiredToTest": [
                    "maximumDepthInMeters",
                    "minimumDepthInMeters"
                ],
                "fatal": false
            },
            {
                "name": "FIRST_OF_CENTURY",
                "code": 1018,
                "description": "first of century",
                "category": "Warning",
                "termsRequiredToTest": [
                    "eventDate",
                    "year",
                    "month",
                    "day"
                ],
                "fatal": false
            },
            {
                "name": "FIRST_OF_MONTH",
                "code": 1016,
                "description": "first of month",
                "category": "Warning",
                "termsRequiredToTest": [
                    "eventDate",
                    "year",
                    "month",
                    "day"
                ],
                "fatal": false
            },
            {
                "name": "FIRST_OF_YEAR",
                "code": 1017,
                "description": "first of year",
                "category": "Warning",
                "termsRequiredToTest": [
                    "eventDate",
                    "year",
                    "month",
                    "day"
                ],
                "fatal": false
            },
            {
                "name": "FOOTPRINT_WKT_INVALID",
                "code": 2015,
                "description": "footprint wkt invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "footprintWKT"
                ],
                "fatal": false
            },
            {
                "name": "FOOTPRINT_WKT_MISMATCH",
                "code": 2014,
                "description": "footprint wkt mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "footprintWKT"
                ],
                "fatal": false
            },
            {
                "name": "GEODETIC_DATUM_INVALID",
                "code": 2004,
                "description": "geodetic datum invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "GEOREFERENCE_POST_OCCURRENCE",
                "code": 1014,
                "description": "georeference post occurrence",
                "category": "Warning",
                "termsRequiredToTest": [
                    "eventDate",
                    "year",
                    "month",
                    "day"
                ],
                "fatal": false
            },
            {
                "name": "ID_PRE_OCCURRENCE",
                "code": 1015,
                "description": "id pre occurrence",
                "category": "Warning",
                "termsRequiredToTest": [
                    "eventDate",
                    "year",
                    "month",
                    "day"
                ],
                "fatal": false
            },
            {
                "name": "INTERPRETATION_ERROR",
                "code": 2050,
                "description": "interpretation error",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": true
            },
            {
                "name": "INVALID_SCIENTIFIC_NAME",
                "code": 1036,
                "description": "invalid scientific name",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "LOCATION_NOT_SUPPLIED",
                "code": 1000,
                "description": "location not supplied",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates"
                ],
                "fatal": false
            },
            {
                "name": "MISSING_COLLECTION_DATE",
                "code": 1013,
                "description": "missing collection date",
                "category": "Warning",
                "termsRequiredToTest": [
                    "eventDate",
                    "year",
                    "month",
                    "day"
                ],
                "fatal": false
            },
            {
                "name": "MODIFIED_DATE_INVALID",
                "code": 2041,
                "description": "modified date invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "modified"
                ],
                "fatal": false
            },
            {
                "name": "MODIFIED_DATE_UNLIKELY",
                "code": 2042,
                "description": "modified date unlikely",
                "category": "Warning",
                "termsRequiredToTest": [
                    "modified"
                ],
                "fatal": false
            },
            {
                "name": "MULTIMEDIA_DATE_INVALID",
                "code": 2047,
                "description": "multimedia date invalid",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "MULTIMEDIA_URI_INVALID",
                "code": 2048,
                "description": "multimedia uri invalid",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "NAME_NOT_SUPPLIED",
                "code": 1032,
                "description": "name not supplied",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "OCCURRENCE_STATUS_INFERRED_FROM_BASIS_OF_RECORD",
                "code": 2055,
                "description": "occurrence status inferred from basis of record",
                "category": "Warning",
                "termsRequiredToTest": [
                    "occurrenceStatus"
                ],
                "fatal": false
            },
            {
                "name": "OCCURRENCE_STATUS_INFERRED_FROM_INDIVIDUAL_COUNT",
                "code": 2054,
                "description": "occurrence status inferred from individual count",
                "category": "Warning",
                "termsRequiredToTest": [
                    "occurrenceStatus"
                ],
                "fatal": false
            },
            {
                "name": "OCCURRENCE_STATUS_UNPARSABLE",
                "code": 2053,
                "description": "occurrence status unparsable",
                "category": "Warning",
                "termsRequiredToTest": [
                    "occurrenceStatus"
                ],
                "fatal": false
            },
            {
                "name": "PRESUMED_NEGATED_LATITUDE",
                "code": 2025,
                "description": "presumed negated latitude",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "PRESUMED_NEGATED_LONGITUDE",
                "code": 2024,
                "description": "presumed negated longitude",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "PRESUMED_SWAPPED_COORDINATE",
                "code": 2023,
                "description": "presumed swapped coordinate",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "RECORDED_DATE_INVALID",
                "code": 2027,
                "description": "recorded date invalid",
                "category": "Warning",
                "termsRequiredToTest": [
                    "day",
                    "year",
                    "month",
                    "eventDate"
                ],
                "fatal": false
            },
            {
                "name": "RECORDED_DATE_MISMATCH",
                "code": 2026,
                "description": "recorded date mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "day",
                    "year",
                    "month",
                    "eventDate"
                ],
                "fatal": false
            },
            {
                "name": "RECORDED_DATE_UNLIKELY",
                "code": 2028,
                "description": "recorded date unlikely",
                "category": "Warning",
                "termsRequiredToTest": [
                    "day",
                    "year",
                    "month",
                    "eventDate"
                ],
                "fatal": false
            },
            {
                "name": "SENSITIVITY_REPORT_INVALID",
                "code": 1037,
                "description": "sensitivity report invalid",
                "category": "Error",
                "termsRequiredToTest": [
                    "scientificName",
                    "taxonConceptID",
                    "decimalLatitude",
                    "decimalLongitude",
                    "eventDate"
                ],
                "fatal": true
            },
            {
                "name": "SENSITIVITY_REPORT_NOT_LOADABLE",
                "code": 1038,
                "description": "sensitivity report not loadable",
                "category": "Error",
                "termsRequiredToTest": [
                    "scientificName",
                    "taxonConceptID",
                    "decimalLatitude",
                    "decimalLongitude",
                    "eventDate"
                ],
                "fatal": true
            },
            {
                "name": "STATE_COORDINATE_MISMATCH",
                "code": 1004,
                "description": "state coordinate mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "country",
                    "countryCode"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_AFFINITY_SPECIES",
                "code": 1019,
                "description": "taxon affinity species",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_CONFER_SPECIES",
                "code": 1021,
                "description": "taxon confer species",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_DEFAULT_MATCH",
                "code": 1035,
                "description": "taxon default match",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_ERROR",
                "code": 1023,
                "description": "taxon error",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_EXCLUDED",
                "code": 1022,
                "description": "taxon excluded",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_EXCLUDED_ASSOCIATED",
                "code": 1020,
                "description": "taxon excluded associated",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_HOMONYM",
                "code": 1024,
                "description": "taxon homonym",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_INDETERMINATE_SPECIES",
                "code": 1025,
                "description": "taxon indeterminate species",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_MATCH_AGGREGATE",
                "code": 2031,
                "description": "taxon match aggregate",
                "category": "Warning",
                "termsRequiredToTest": [
                    "order",
                    "family",
                    "scientificNameAuthorship",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "genericName",
                    "kingdom",
                    "phylum",
                    "class",
                    "genus",
                    "scientificName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_MATCH_FUZZY",
                "code": 2029,
                "description": "taxon match fuzzy",
                "category": "Warning",
                "termsRequiredToTest": [
                    "order",
                    "family",
                    "scientificNameAuthorship",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "genericName",
                    "kingdom",
                    "phylum",
                    "class",
                    "genus",
                    "scientificName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_MATCH_NONE",
                "code": 2032,
                "description": "taxon match none",
                "category": "Warning",
                "termsRequiredToTest": [
                    "order",
                    "family",
                    "scientificNameAuthorship",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "genericName",
                    "kingdom",
                    "phylum",
                    "class",
                    "genus",
                    "scientificName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_MISAPPLIED",
                "code": 1027,
                "description": "taxon misapplied",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_MISAPPLIED_MATCHED",
                "code": 1026,
                "description": "taxon misapplied matched",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_PARENT_CHILD_SYNONYM",
                "code": 1028,
                "description": "taxon parent child synonym",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_QUESTION_SPECIES",
                "code": 1029,
                "description": "taxon question species",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_SCOPE_MISMATCH",
                "code": 1034,
                "description": "taxon scope mismatch",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "TAXON_SPECIES_PLURAL",
                "code": 1030,
                "description": "taxon species plural",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "UNCERTAINTY_IN_PRECISION",
                "code": 1002,
                "description": "uncertainty in precision",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "UNCERTAINTY_NOT_SPECIFIED",
                "code": 1003,
                "description": "uncertainty not specified",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum"
                ],
                "fatal": false
            },
            {
                "name": "UNKNOWN_COUNTRY_NAME",
                "code": 1005,
                "description": "unknown country name",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimLatitude",
                    "verbatimLongitude",
                    "verbatimCoordinates",
                    "geodeticDatum",
                    "country",
                    "countryCode"
                ],
                "fatal": false
            },
            {
                "name": "UNKNOWN_KINGDOM",
                "code": 1033,
                "description": "unknown kingdom",
                "category": "Warning",
                "termsRequiredToTest": [
                    "kingdom",
                    "phylum",
                    "class",
                    "order",
                    "family",
                    "genus",
                    "scientificName",
                    "scientificNameAuthorship",
                    "genericName",
                    "specificEpithet",
                    "infraspecificEpithet",
                    "taxonRank",
                    "vernacularName"
                ],
                "fatal": false
            },
            {
                "name": "ZERO_COORDINATE",
                "code": 2000,
                "description": "zero coordinate",
                "category": "Warning",
                "termsRequiredToTest": [
                    "decimalLatitude",
                    "decimalLongitude",
                    "verbatimCoordinates",
                    "verbatimLatitude",
                    "verbatimLongitude"
                ],
                "fatal": false
            },
            {
                "name": "biosecurityIssue",
                "code": 20021,
                "description": "Biosecurity issue",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "detectedOutlier",
                "code": 20,
                "description": "Suspected outlier",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": true
            },
            {
                "name": "geospatialIssue",
                "code": 0,
                "description": "Geospatial issue",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": true
            },
            {
                "name": "habitatMismatch",
                "code": 19,
                "description": "Habitat incorrect for species",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": true
            },
            {
                "name": "identificationIncorrect",
                "code": 10007,
                "description": "Taxon misidentified",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "taxonomicIssue",
                "code": 10000,
                "description": "Taxonomic issue",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "temporalIssue",
                "code": 30000,
                "description": "Temporal issue",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "userAssertionOther",
                "code": 20019,
                "description": "Other error",
                "category": "Error",
                "termsRequiredToTest": [],
                "fatal": false
            },
            {
                "name": "userDuplicateRecord",
                "code": 20020,
                "description": "The occurrence appears to be a duplicate",
                "category": "Warning",
                "termsRequiredToTest": [],
                "fatal": false
            }
        ]
    },
    "userAssertions": [],
    "sensitive": false
}
```

Retrieve full record details. If an JWT is supplied, and the user has the appropriate permissions the results might include sensitive species data if available. 

#### HTTP Request
`GET <%= I18n.t(:biocacheServiceApiUrl) %>/occurrences/{recordUuid}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
recordUuid | Y | | The Occurrence record uuid

## 12.3 DELETE /occurrences/{recordUuid}/assertions/delete <p style="display: inline;">&#128274;</p>
```shell
curl -X 'DELETE' '<%= I18n.t(:biocacheServiceApiUrl) %>/occurrences/0c6e3ea5-ff28-4a09-8b80-e5db0e1258a3/assertions/delete?assertionUuid=4ac6a19e-727d-4243-9ab6-4f7597da650e' \
  -H 'accept: application/json' -H "Authorization: Bearer {access_token}"

This above command returns a 200 OK with an empty response body on a successful deletion
```

#### HTTP Request
`DELETE <%= I18n.t(:biocacheServiceApiUrl) %>/occurrences/{recordUuid}/assertions/delete`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
recordUuid | Y | | The Occurrence record uuid
#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
assertionUuid | Y | | The assertion uuid

## 12.4 GET /autocomplete/search 
```shell
curl -X 'GET' '<%= I18n.t(:biocacheServiceApiUrl) %>/autocomplete/search?q=kanga&pageSize=10&all=false&synonyms=true&counts=true' \
  -H 'accept: application/json'

The above command returns JSON structured like this:
{
  "searchResults": {
    "startIndex": 0,
    "totalRecords": 107,
    "query": "kanga",
    "pageSize": 10,
    "sort": "score",
    "dir": "desc",
    "results": [
      {
        "imageCount": 0,
        "idxType": "TAXON",
        "nameComplete": "Kangarina",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "score": 1.7777777,
        "highlight": "<strong>Kanga</strong>rina",
        "tracksCount": 0,
        "linkIdentifier": "NZOR-6-35113",
        "rank": "genus",
        "checklistsCount": 0,
        "order": "Podocopida",
        "isAustralian": "recorded",
        "right": "179936",
        "kingdom": "Animalia",
        "phylum": "Arthropoda",
        "classs": "Ostracoda",
        "rawRank": "GENUS",
        "left": "179934",
        "genus": "Kangarina",
        "rankId": 6000,
        "parentGuid": "https://biodiversity.org.au/afd/taxa/a1095e70-e50a-4d7a-9ef3-eb37300d6492",
        "name": "Kangarina",
        "guid": "NZOR-6-35113",
        "family": "Leptocytheridae",
        "occCount": 2
      },
      {
        "imageCount": 0,
        "idxType": "TAXON",
        "nameComplete": "Kangarosa",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "score": 1.7777777,
        "highlight": "<strong>Kanga</strong>rosa",
        "tracksCount": 0,
        "linkIdentifier": "https://biodiversity.org.au/afd/taxa/61f93eb9-6b62-4d51-be8c-3d267d163ba3",
        "rank": "genus",
        "checklistsCount": 0,
        "order": "Araneae",
        "author": "Framenau, 2010",
        "isAustralian": "recorded",
        "right": "434701",
        "kingdom": "Animalia",
        "phylum": "Arthropoda",
        "classs": "Arachnida",
        "rawRank": "GENUS",
        "left": "434681",
        "genus": "Kangarosa",
        "rankId": 6000,
        "parentGuid": "https://biodiversity.org.au/afd/taxa/6235e37b-5c13-43aa-b242-b16689ce7d7c",
        "name": "Kangarosa",
        "guid": "https://biodiversity.org.au/afd/taxa/61f93eb9-6b62-4d51-be8c-3d267d163ba3",
        "family": "Lycosidae",
        "occCount": 444
      },
      {
        "imageCount": 0,
        "commonName": [
          "Kangaroo Thorn",
          "Prickly Moses",
          "Hedge Acacia",
          "Hedge Wattle",
          "Prickly Wattle",
          "Prickly Acacia",
          "Prickly Shrub Wattle",
          "Acacia Hedge"
        ],
        "idxType": "TAXON",
        "nameComplete": "Acacia paradoxa",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "Prickly Moses",
        "score": 2,
        "highlight": "Prickly Moses",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/taxon/apni/51310608",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Fabales",
        "author": "DC.",
        "isAustralian": "recorded",
        "right": "596416",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "596414",
        "genus": "Acacia",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51382879",
        "name": "Acacia paradoxa",
        "guid": "https://id.biodiversity.org.au/taxon/apni/51310608",
        "family": "Fabaceae",
        "occCount": 16989
      },
      {
        "imageCount": 0,
        "commonName": [
          "Soap Grass",
          "Kangaroo Grass",
          "Turpentine Grass",
          "Barbed-wire Grass",
          "Barb-wire Grass",
          "Barbed Wire Grass",
          "Barb Wire Grass",
          "Barded Wire Grass"
        ],
        "idxType": "TAXON",
        "nameComplete": "Cymbopogon refractus",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "Barb-wire Grass",
        "score": 2,
        "highlight": "Barb-wire Grass",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2914400",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Poales",
        "author": "(R.Br.) A.Camus",
        "isAustralian": "recorded",
        "right": "647732",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "647732",
        "genus": "Cymbopogon",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/node/apni/2911780",
        "name": "Cymbopogon refractus",
        "guid": "https://id.biodiversity.org.au/node/apni/2914400",
        "family": "Poaceae",
        "occCount": 18339
      },
      {
        "imageCount": 0,
        "commonName": [
          "Port Lincoln Mallee",
          "Cong Mallee"
        ],
        "idxType": "TAXON",
        "nameComplete": "Eucalyptus conglobata",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "Cong Mallee",
        "score": 2,
        "highlight": "Cong Mallee",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2901637",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Myrtales",
        "author": "(R.Br. ex Benth.) Maiden",
        "isAustralian": "recorded",
        "right": "567908",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "567904",
        "genus": "Eucalyptus",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51360942",
        "name": "Eucalyptus conglobata",
        "guid": "https://id.biodiversity.org.au/node/apni/2901637",
        "family": "Myrtaceae",
        "occCount": 753
      },
      {
        "imageCount": 0,
        "commonName": [
          "Congoo Mallee",
          "Waikerie Mallee",
          "Bunurdurk",
          "White Mallee",
          "Weir Mallee",
          "Dumosa Mallee"
        ],
        "idxType": "TAXON",
        "nameComplete": "Eucalyptus dumosa",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "White Mallee",
        "score": 2,
        "highlight": "White Mallee",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2894653",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Myrtales",
        "author": "A.Cunn. ex J.Oxley",
        "isAustralian": "recorded",
        "right": "567536",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "567534",
        "genus": "Eucalyptus",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51360942",
        "name": "Eucalyptus dumosa",
        "guid": "https://id.biodiversity.org.au/node/apni/2894653",
        "family": "Myrtaceae",
        "occCount": 8110
      },
      {
        "imageCount": 0,
        "idxType": "TAXON",
        "nameComplete": "Eucalyptus phenax",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "score": 2,
        "highlight": "<strong>Kanga</strong>roo Island Mallee",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/7675695",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Myrtales",
        "author": "Brooker & Slee",
        "isAustralian": "recorded",
        "right": "569206",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "569200",
        "genus": "Eucalyptus",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51360942",
        "name": "Eucalyptus phenax",
        "guid": "https://id.biodiversity.org.au/node/apni/7675695",
        "family": "Myrtaceae",
        "occCount": 6330
      },
      {
        "imageCount": 0,
        "commonName": [
          "Kingscote Mallee"
        ],
        "idxType": "TAXON",
        "nameComplete": "Eucalyptus rugosa",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "Kingscote Mallee",
        "score": 2,
        "highlight": "Kingscote Mallee",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2898276",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Myrtales",
        "author": "R.Br. ex Blakely",
        "isAustralian": "recorded",
        "right": "567732",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "567732",
        "genus": "Eucalyptus",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51360942",
        "name": "Eucalyptus rugosa",
        "guid": "https://id.biodiversity.org.au/node/apni/2898276",
        "family": "Myrtaceae",
        "occCount": 1090
      },
      {
        "imageCount": 0,
        "idxType": "TAXON",
        "nameComplete": "Macrozamia flexuosa",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "score": 2,
        "highlight": "<strong>Kanga</strong>roo-nut",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2897645",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Cycadales",
        "author": "C.Moore",
        "isAustralian": "recorded",
        "right": "531091",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "531091",
        "genus": "Macrozamia",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51294694",
        "name": "Macrozamia flexuosa",
        "guid": "https://id.biodiversity.org.au/node/apni/2897645",
        "family": "Zamiaceae",
        "occCount": 643
      },
      {
        "imageCount": 0,
        "commonName": [
          "Native Oatgrass",
          "Tall Oat Grass",
          "Native Oat Grass",
          "Tall Oatgrass",
          "Oat Kangaroo Grass",
          "Kangaroo-grass"
        ],
        "idxType": "TAXON",
        "nameComplete": "Themeda avenacea",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "Native Oatgrass",
        "score": 2,
        "highlight": "Native Oatgrass",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2916981",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Poales",
        "author": "(F.Muell.) Hack. ex Maiden & Betche",
        "isAustralian": "recorded",
        "right": "650608",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "650608",
        "genus": "Themeda",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51291520",
        "name": "Themeda avenacea",
        "guid": "https://id.biodiversity.org.au/node/apni/2916981",
        "family": "Poaceae",
        "occCount": 1004
      },
      {
        "imageCount": 0,
        "commonName": [
          "Grader Grass"
        ],
        "idxType": "TAXON",
        "nameComplete": "Themeda quadrivalvis",
        "hasChildren": false,
        "isExcluded": false,
        "distributionsCount": 0,
        "commonNameSingle": "Grader Grass",
        "score": 2,
        "highlight": "Grader Grass",
        "tracksCount": 0,
        "linkIdentifier": "https://id.biodiversity.org.au/node/apni/2891763",
        "rank": "species",
        "checklistsCount": 0,
        "order": "Poales",
        "author": "(L.) Kuntze",
        "isAustralian": "recorded",
        "right": "650606",
        "kingdom": "Plantae",
        "phylum": "Charophyta",
        "classs": "Equisetopsida",
        "rawRank": "SPECIES",
        "left": "650606",
        "genus": "Themeda",
        "rankId": 7000,
        "parentGuid": "https://id.biodiversity.org.au/taxon/apni/51291520",
        "name": "Themeda quadrivalvis",
        "guid": "https://id.biodiversity.org.au/node/apni/2891763",
        "family": "Poaceae",
        "occCount": 3568
      }
    ],
    "status": "OK"
  }
}
```

#### HTTP Request
`DELETE <%= I18n.t(:biocacheServiceApiUrl) %>/autocomplete/search`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q | Y | | The value to auto complete e.g. q=Fish
fq | Y | | Restrict search results to these filter queries.
pageSize | Y | | Max number of results to return
all | Y | | 
synonyms | Y | | 
counts | Y | | 




