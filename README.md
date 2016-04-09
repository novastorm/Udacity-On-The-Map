#On The Map

On The Map allows users to share their location and a URL with fellow students. On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves on the map.

---

Install remote frameworks via Carthage

~~~
carthage upgrade --platform iOS
~~~

Resource authorization

* add the appropriate API Key and ApplicationId to the file:

On the Map/UdacityParseClientConstants.swift

~~~
extension UdacityParseClient {

struct Constants {
// MARK: API Key
static let APIKey = "REST API Key"

// MARK: Application Id
static let ApplicationId = "Parse Application ID"
~~~