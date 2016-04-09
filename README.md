Install remote frameworks via Carthage

carthage upgrade --platform iOS


Resource authorization

* add the appropriate API Key and ApplicationId to the file:

On the Map/UdacityParseClientConstants.swift

extension UdacityParseClient {

struct Constants {
// MARK: API Key
static let APIKey = "REST API Key"

// MARK: Application Id
static let ApplicationId = "Parse Application ID"