# GET vs POST
| Area of Comparison | GET | POST |
| --- | --- | --- |
| BACK button/Reload | Harmless | Data will be re-submitted (the browser should alert the user with that) |
| Bookmarked | Can be bookmarked | Cannot be bookmarked |
| Cached | Can be cached | Not cached |
| Encoding Type | application/x-www-form-urlencoded | application/x-www-form-urlencoded or multipart/form-data. Use multipart encoding for binary data |
| History | Parameters remain in browser History | Parameters are not saved in browser history |
| Restrictions on data length	| Yes, when sending data, the GET method adds the data to the URL; and the length of a URL is limited (maximum URL length is 2048 characters) | No restrictions |
| Restrictions on data type | Only ASCII characters allowed | No restrictions. Binary data is also allowed |
| Security | GET is less secure compared to POST because data send is part of the URL. Never use GET when sending passwords or other sensitive information! | POST is a little safer than GET because the parameters are not stored in browser history or in web server logs |
| Visbility | Data is visible to everyone in the URL | Data is not displayed in the url |