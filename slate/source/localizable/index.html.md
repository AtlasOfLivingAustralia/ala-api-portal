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

# Authentication

Most of the ALA APIs are publicly accessible and do not required authentication. For the API endpoints that are protected a JWT access token is used to authenticate requests.

Open ID Connect is used to obtain an access token, once an access token is obtained it should be passed as a bearer token in the HTTP Authentication header.

`Authorization: Bearer <access_token>`

We support multiple ways to obtain an access token:
 
 - [Client Credentials](#client-credentials)
 - [Authentication Code Flow](#authentication-code-flow)
 - [Implicit Flow](#implicit-flow)

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

The Client Credentials grant type is used for machine to machine authentication where no there is no user interaction.

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
redirect_uri | Y | | The URL where the authentication server redirects the browser after the user is authorizes.
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
redirect_uri | Y | | The URL where the authentication server redirects the browser after the user is authorizes.
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
redirect_uri | Y | | The URL where the authentication server redirects the browser after the user is authorizes.

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

## 2. Logger service

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=logger">Open API specification</a>
</aside>

## 2.1 GET service/emailBreakdown
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

## 2.2 GET service/logger/events
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

## 2.3 GET service/reasonBreakdown
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

## 2.4 GET service/reasonBreakdownMonthly
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

## 2.5 GET service/logger/reasons
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

## 2.6 GET service/sourceBreakdown
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

## 2.7 GET service/logger/sources
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

## 2.8 GET service/totalsByType
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

## 2.9 GET service/logger/get.json
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

## 3. User details

Access the user details platform.


<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=userdetails">Open API specification</a>
</aside>

## 3.1 GET /ws/flickr
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

## 3.2 GET /ws/getUserStats
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

## 3.3 GET /userDetails/byRole <p style="display: inline;">&#128274;</p>
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

## 3.4 POST /userDetails/getUserDetails <p style="display: inline;">&#128274;</p>
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

## 3.5 POST /userDetails/getUserDetailsFromIdList <p style="display: inline;">&#128274;</p>
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

## 3.6 GET /userDetails/search <p style="display: inline;">&#128274;</p>
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

## 3.7 GET /property/getProperty <p style="display: inline;">&#128274;</p>
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

## 3.8 POST /property/saveProperty <p style="display: inline;">&#128274;</p>
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

## 4. Biodiversity Information Explorer Service
<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=bie-index">Open API specification</a>
</aside>


## 4.1 GET /api/services/all <p style="display: inline;">&#128274;</p>
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

## 4.2 GET /api/services/status/{id} <p style="display: inline;">&#128274;</p>
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

#### HTTP Request
`GET <%= I18n.t(:bieIndexAPIUrl) %>/api/services/status/{id}`

#### Path Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
id | Y | | The import job  Id

## 4.3 GET /search/auto.json 
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

#### HTTP Request
`GET <%= I18n.t(:bieIndexAPIUrl) %>/search/auto.json`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
q | Y | |The value to auto complete e.g. q=Fish
idxType | N | |The index type to limit . Values include: * TAXON * REGION * COLLECTION * INSTITUTION * DATASET
kingdom | N | |The higher-order taxonomic rank to limit the result
geoOnly | N | |(Not Implemented) Limit value to limit result with geospatial occurrence records
limit | N | |The maximum number of results to return (default = 10)


## 5. Species lists

Interact with species lists, including get list details and create a list.

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=specieslist">Open API specification</a>
</aside>

## 5.1 GET /ws/speciesList/{druid} 
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

## 5.2 POST /ws/speciesListPost <p style="display: inline;">&#128274;</p>
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


## 5.3 POST /ws/listCommonKeys 
```shell
curl -X 'POST' '<%= I18n.t(:specieslistIndexAPIUrl) %>/ws/listCommonKeys?druid={druid}' \
  -H 'accept: application/json'

The above command returns JSON structured like this:

["vernacular name"]
```

Get a list of keys from KVP common across a list multiple species lists

#### HTTP Request
`GET <%= I18n.t(:specieslistIndexAPIUrl) %>/ws/listCommonKeys`

#### Query Parameters

Parameter | Mandatory | Default | Description
--------- | --------- | ------- | -----------
druid | Y | | A comma separated list of druids to query

## 6. DOI service

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=doi">Open API specification</a>
</aside>

## 6.1 GET api/doi
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

## 6.2 GET api/doi/{id}
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

## 6.3 GET api/doi/search
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

## 6.4 GET api/doi/{id}/download
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

## 6.5 POST api/doi <p style="display: inline;">&#128274;</p>
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

## 6.6 POST api/doi/{id} <p style="display: inline;">&#128274;</p>
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

## 6.7 PUT api/doi/{id} <p style="display: inline;">&#128274;</p>
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

## 6.8 PATCH api/doi/{id} <p style="display: inline;">&#128274;</p>
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

## 7. Biocollect

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=biocollect">Open API specification</a>
</aside>

## 7.1 GET ws/bioactivity/delete/{id} <p style="display: inline;">&#128274;</p>
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

## 7.2 GET ws/bioactivity/model/{id} <p style="display: inline;">&#128274;</p>
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

## 7.3 GET ws/bioactivity/data/{id} <p style="display: inline;">&#128274;</p>
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

## 7.4 GET ws/bioactivity/map <p style="display: inline;">&#128274;</p>
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
Get sites associated with an activities

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

## 7.5 GET ws/bioactivity/search <p style="display: inline;">&#128274;</p>
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

## 7.6 GET ws/species/uniqueId
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

## 7.7 GET ws/survey/list/{id}
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
version | N | | The date and time on which project activity was created. Version number unit is milliseconds since epoch.

## 7.8 GET ws/project/search <p style="display: inline;">&#128274;</p>
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
status | N | | Return active or completed projects. Available values : active, completed
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



