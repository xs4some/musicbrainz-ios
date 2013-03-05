//
//  BasicService.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 04-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "MKNetworkOperation.h"

typedef enum {
    HTTPGET,
    HTTPPOST
} HTTPMETHOD;

typedef enum {
    HTTPOK = 200,
    HTTPBADREQUEST = 400,
    HTTPUNAUTHORISED = 401,
    HTTPFORBIDDEN = 403,
    HTTPPRECONDITIONFAILED = 412,
    HTTPSERVERERROR = 500,
    HTTPINVALIDRESPONSE
} ErrorResponse;

@interface BasicService : MKNetworkOperation

-(id)initServiceWithURL:(NSString *)urlString params:(NSMutableDictionary *)params method:(HTTPMETHOD)method;

@end
