//
//  ReleaseService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "ReleaseService.h"
#import "Medium.h"
#import "MediumService.h"
#import "ArtistService.h"
#import "AppDelegate.h"

@implementation ReleaseService

-(id)initServiceWithReleaseId:(NSString *)releaseId andParams:(NSMutableDictionary *)params
{
    if (params == nil)
    {
        params = [NSMutableDictionary dictionaryWithDictionary: @{@"inc":@"recordings+release-groups"}];
    }
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@/%@", kWebServiceRoot, kWebServiceRelease, releaseId];

    self = [self initServiceWithURL:serviceURL params:params method:HTTPGET];

    return self;
}

-(void)getReleaseOnCompletion:(void(^)(Release *release))completionBlock onError:(MKNKErrorBlock)errorBlock
{
    [self addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
        if (![completedOperation isCachedResponse])
        {
            NSLog(@"%@", completedOperation.responseJSON);

            if (completedOperation.responseJSON)
            {
                if ([completedOperation.responseJSON isKindOfClass:[NSDictionary class]])
                {
                    completionBlock([ReleaseService releaseWithDictionary:completedOperation.responseJSON]);
                } else
                {
                    NSError *error = [[NSError alloc] initWithDomain:nil code:HTTPSERVERERROR userInfo:nil];
                    errorBlock(error);
                }
            } else
            {
                // TODO: Add iOS 4.3 support with SBJSON
                NSError *error = [[NSError alloc] initWithDomain:nil code:HTTPSERVERERROR userInfo:nil];
                errorBlock(error);
            }

        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        errorBlock(error);
    }];

    [ApplicationDelegate.network enqueueOperation:self forceReload:YES];
}


+(NSArray *)releasesWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Release *release = [ReleaseService releaseWithDictionary:dictionary];

        if (release)
        {
            [results addObject:release];
        }
    }

    return results;
}

+(Release *)releaseWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
    {
#if DEBUG
        NSLog(@"Release: Missing elements in response\n%@", dictionary);
#endif
        return nil;
    }

    Release *release = [[Release alloc] init];

    release.releaseId = [dictionary objectForKey:@"id"];
    release.title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"media"])
    {
        release.media = [MediumService mediaWithArray:[dictionary objectForKey:@"media"]];
    }

    if ([dictionary objectForKey:@"score"])
    {
        release.score = [dictionary objectForKey:@"score"];
    }

    if ([dictionary objectForKey:@"country"])
    {
        release.country = [dictionary objectForKey:@"country"];
    }

    if ([dictionary objectForKey:@"date"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];

        release.date = [dateFormatter dateFromString:[dictionary objectForKey:@"date"]];
    }

    if ([dictionary objectForKey:@"release-group"])
    {
        release.releaseGroup = [dictionary objectForKey:@"release-group"];
    }

    if ([dictionary objectForKey:@"artist-credit"])
    {
        release.artists = [ArtistService artistsWithArray:[dictionary objectForKey:@"artist-credit"]];
    }

    if ([dictionary objectForKey:@"packaging"])
    {
        release.packaging = [dictionary objectForKey:@"packaging"];
    }

    if ([dictionary objectForKey:@"status"])
    {
        release.status = [dictionary objectForKey:@"status"];
    }

    if ([dictionary objectForKey:@"quality"])
    {
        release.quality = [dictionary objectForKey:@"quality"];
    }

    return release;
}

@end