//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create HTTP server.
let server = HTTPServer()

// Create the container variable for routes to be added to.
var routes = Routes()

// Register your own routes and handlers
// This is an example "Hello, world!" HTML route
routes.add(method: .get, uri: "/", handler: {
    request, response in
    // Setting the response content type explicitly to text/html
    response.setHeader(.contentType, value: "text/html")
    // Adding some HTML to the response body object
    response.appendBody(string: "...")
    // Signalling that the request is completed
    response.completed()
})

// Adding a route to handle the GET people list URL
routes.add(method: .get, uri: "/json", handler: {
    request, response in
    
    response.setHeader(.contentType, value: "application/json")
    
    var file :String! = "default"
    for tuple in request.queryParams {
        if("test"==tuple.0.lowercased()) {
            print("TEST parameter detected")
            file = tuple.1
        } else {
            print("\(tuple.0) = \(tuple.1)")
        }
    }
    var result = "something went really wrong, please check your server configuraton"
    let path : String = Bundle.main.path(forResource: file, ofType: "json")!
    do {
        result = try String(contentsOfFile: path)
    } catch {}
    response.appendBody(string: result)
    response.completed()
})

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
