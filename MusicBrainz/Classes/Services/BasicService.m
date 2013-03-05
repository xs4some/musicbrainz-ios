//
//  BasicService.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 04-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"
#import "Const.h"

@implementation BasicService

-(id)initServiceWithURL:(NSString *)serviceUrl params:(NSMutableDictionary *)params method:(HTTPMETHOD)method
{

    NSString *httpMethod = nil;
    
    switch (method)
    {
        case HTTPPOST:
            httpMethod = @"POST";
            break;
            
        case HTTPGET:
        default:
            httpMethod = @"GET";
            break;
    }
    
    NSString *userAgent = [NSString stringWithFormat:kUserAgent, kBuildVersion, kBuildDate];
    
    [params setObject:kClientId forKey:@"client"];
    [params setObject:@"json" forKey:@"fmt"];
    
    self = [super initWithURLString:serviceUrl params:params httpMethod:httpMethod];
    
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"User-Agent", nil];
    
    [self addHeaders:headers];
    
    return self;
    
}

@end
