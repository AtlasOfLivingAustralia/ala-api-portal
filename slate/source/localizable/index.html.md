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

# Documentation

Welcome to the ALA API Portfolio Hub.  

We’ve recently moved to this API Gateway to streamline access and improve security for end-users by incorporating user authentication. ALA data are still open and freely accessible. 
For more information or assistance, please contact [support@ala.org.au](mailto:support@ala.org.au). 

API Endpoint: [api.ala.org.au](https://api.ala.org.au/)

Legacy API and documentation are still available at [api-legacy.ala.org.au](https://api-legacy.ala.org.au/)

ALA APIs allow two main methods of access

1. No Authentication - The majority of the API endpoints across all published ALA services do not require authentication and are open to public access.

2. JWT Authentication/Advanced Access - For API endpoints that provide write access and read access to sensitive or private data, the requestor (user or machine) needs to be authenticated. JWT access token can used to authenticate requests. The [Authentication](#authentication) section provides details on JWT usage.

# Authentication

Open ID Connect is used to obtain an access token. Once an access token is obtained it should be passed as a bearer token in the HTTP Authentication header.


`Authorization: Bearer <access_token>`

Client application details are required for access token generation. Please follow this <a href="<%= I18n.t(:tokensAppUrl) %>" >step-by-step guide</a> for <strong>Client Registration</strong> and <strong>Token Generation</strong>.  The <strong>Token Generation</strong> functionality of the guide implements the ALA recommended [Authentication Code Flow using PKCE](#authentication-code-flow) flow mentioned below. 

We support multiple ways to obtain an access token:

 - [Client Credentials](#client-credentials)
 - [Authentication Code Flow](#authentication-code-flow)
 - [Implicit Flow](#implicit-flow)

  The Postman Collection below shows some examples of the above token generation flows and the subsequent usage of the generated token.

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

# Services
<!--
## Species profile

Lookup by species (taxonomic name), including bulk species lookup, and downloads for both. You can also get a list of higher taxa for a requested taxon. 

## Occurrence  

Search and download occurrence records for specific groups, including a faceted search. There is also an option to ingest data. 
For full api documentation see [Open API specification](./openapi/index.html?urls.primaryName=biocache)

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

Services for interacting with the ALA  <a href="https://alerts.ala.org.au" target="_blank">Alerts</a> app, including view alert details, unsubscribe from and create an alert. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=alerts">Open API specification</a>


&nbsp;

## 2. Occurrences

Services for interacting species occurrence records. 

Explore interactively on the ALA <a href="https://biocache.ala.org.au" target="_blank">BioCache</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=occurrences">Open API specification</a>

&nbsp;

## 3. Surveys


Interact with the ALA <a href="https://biocollect.ala.org.au" target="_blank">BioCollect</a> app, such as searching for projects, surveys and activities. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=surveys">Open API specification</a>

&nbsp;

## 4. Species

Services for species profile data. 

Explore interactively on the ALA <a href="https://bie.ala.org.au" target="_blank">Biodiversity Information Explorer</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=species">Open API specification</a>

&nbsp;


## 5. Metadata

Services for interacting with attribution information, such as data provider metadata and citations. 

Explore interactively on the ALA <a href="https://collections.ala.org.au" target="_blank">Collectory</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=metadata">Open API specification</a>

&nbsp;

## 6. Data Quality Service

Interact with ALA data quality filters. 

Explore interactively on the ALA <a href="https://data-quality-service.ala.org.au" target="_blank">Data Quality Filter Service</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=data-quality-service">Open API specification</a>

&nbsp;

## 7. DOI

Generate DOIs for ALA applications. 

Explore interactively on the ALA <a href="https://doi.ala.org.au" target="_blank">DOI</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=doi">Open API specification</a>

&nbsp;

## 8. Galah
Access a curated list of common  ALA services. 

ALA services required for Galah can be accessed via Common APIs, a curated list of APIs commonly used by the ALA, partners, and public users. An API key (which can be requested from ALA Support) is required for access. Please note that this API key is not used for authentication but rather for usage tracking, monitoring, and rate limiting due to the expected high frequency of usage on these endpoints. The postman *'Run in Postman'* link below demonstrates the usage of these APIs with API key. Further usage documentation on these APIs can be found in the corresponding service sections (e.g. Alerts, Logger etc) under [Services](#services).

  [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/23926959-f59627be-b952-4939-bdd9-3b16236c143c?action=collection%2Ffork&collection-url=entityId%3D23926959-f59627be-b952-4939-bdd9-3b16236c143c%26entityType%3Dcollection%26workspaceId%3De9363855-ef16-46ba-bf16-cee7f7f2f8e9)

For full api documentation see <a href="./openapi/index.html?urls.primaryName=common">Open API specification</a>

&nbsp;


## 9. Images

Access ALA images, such as finding an image by keyword.

Explore interactively on the ALA <a href="https://images.ala.org.au" target="_blank">Images</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=images">Open API specification</a>

&nbsp;


## 10. Download statistics

Interact with the ALA Logger <a href="https://logger.ala.org.au" target="_blank">Logger</a>  webapp, such as getting event types and reason breakdowns.


For full api documentation see <a href="./openapi/index.html?urls.primaryName=download-statistics">Open API specification</a>

&nbsp;

<!-- Uncomment 11. Species lists and traits,  12. User details and 13. Spatial  for prod deployment.  Comment them out for dev and test -->

<!-- ## 11. Species lists and traits

Interact with   <a href="https://lists.ala.org.au" target="_blank">species lists</a> , including get list details and create a list.

For full api documentation see <a href="./openapi/index.html?urls.primaryName=specieslist">Open API specification</a>

&nbsp;

## 12. User details

Access the ALA   <a href="https://auth.ala.org.au/userdetails/" target="_blank">user details</a>  platform, such as a total count of users in the system and users by role.


For full api documentation see <a href="./openapi/index.html?urls.primaryName=userdetails">Open API specification</a>

&nbsp;

## 13. Spatial 

Services for interacting with ALA Spatial services

Explore interactively on the ALA <a href="https://spatial.ala.org.au" target="_blank">Spatial</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=spatial">Open API specification</a>

&nbsp; -->

<!-- Uncomment 11. 12. 13. 14. 15. for test and dev deploys. Comment them out for prod  -->

&nbsp;

## 11. Profiles service

Services for interacting with ALA Profile collections 

Explore interactively on the ALA <a href="https://profiles.ala.org.au" target="_blank">Profile collection</a> app. 

<aside class="notice">
For full api documentation see <a href="./openapi/index.html?urls.primaryName=profiles">Open API specification</a>
</aside>

&nbsp;


## 12. Species lists and traits

Interact with   <a href="https://lists.ala.org.au" target="_blank">species lists</a> , including get list details and create a list.

For full api documentation see <a href="./openapi/index.html?urls.primaryName=specieslist">Open API specification</a>

&nbsp;

## 13. Spatial 

Services for interacting with ALA Spatial services

Explore interactively on the ALA <a href="https://spatial.ala.org.au" target="_blank">Spatial</a> app. 

For full api documentation see <a href="./openapi/index.html?urls.primaryName=spatial">Open API specification</a>

&nbsp;

## 14. User details

Access the ALA   <a href="https://auth.ala.org.au/userdetails/" target="_blank">user details</a>  platform, such as a total count of users in the system and users by role.


For full api documentation see <a href="./openapi/index.html?urls.primaryName=userdetails">Open API specification</a>

&nbsp;

## 15. Namematching

Access the ALA   <a href="https://namematching-ws.ala.org.au/" target="_blank">namematching</a> service.

For full api documentation see <a href="./openapi/index.html?urls.primaryName=namematching">Open API specification</a>

&nbsp;

## 16. Events

Access the ALA   <a href="https://events-test.ala.org.au/" target="_blank">Events</a> app.

For full api documentation see <a href="./openapi/index.html?urls.primaryName=events">Open API specification</a>

&nbsp;

## 17. Ecodata

Services for the <a href="https://fieldcapture.ala.org.au/" target="_blank">MERIT</a> and <a href="https://biocollect.ala.org.au/" target="_blank">BioCollect</a> applications.

For full api documentation see <a href="./openapi/index.html?urls.primaryName=ecodata">Open API specification</a>

&nbsp;
