//
//  SASJSONParser.h
//  Save a Selfie
//
//  Created by Stephen Fox on 10/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This is a utility class for parsing JSON responses
 from the Save a Selfie server.
*/
@interface SASJSONParser : NSObject

/**
 Parses the following JSON:
 
    Response Format {
      "responseMessage": {
      "token_status": "201"
      "insert_status": "103"
      }
    }
 
 The returned dictionary object will contain 'token_status' & 'insert_status'.
 */
+ (NSDictionary*) parseSignUpResponse:(NSDictionary*) json;

/// --------------------------------------------------------------

/**
 The next two methods parse the getAllSelfies request which 
 comes in the following format:
 
 {
  "responseMessage": {
    "token_status": "201"
  },
 
  "data": [ {
    "lat" : "53.330965", // Latitude of the selfie location
    "lng" : "-6.259247", // Longitude of the selfie location
    "add" : "17 Synge Street, Dublin 8", // Address of the selfie location
    "aid_type" : "First Aid", // Type of device on the selfie location
    "postal_code" : "Dublin 6" // Postal code of the selfie location eg, Dublin 8
    "file" : "56d19776bd5ff00003b847ec" // Selfie from camera
  }]
 }
 */



/**
 Parses the following JSON from the getAllSelfies request.
   { 
      "responseMessage": {
        "token_status": "201" <- This is the object returned.
       },

 */
+ (NSObject*) parseGetAllSelfieResponseMessage:(NSDictionary*) json;


/**
 Parses the following JSON from the getAllSelfies request.
 "data": [ {
  "lat" : "53.330965",
  "lng" : "-6.259247",
  "add" : "17 Synge Street, Dublin 8",
  "aid_type" : "First Aid",
  "postal_code" : "Dublin 6"
  "file" : "56d19776bd5ff00003b847ec"
 }] */
+ (NSArray*) parseGetAllSelfieData:(NSDictionary*) json;


/// --------------------------------------------------------------
@end
