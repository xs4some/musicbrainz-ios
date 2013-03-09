//
//  ReleaseService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "ReleaseService.h"

@implementation ReleaseService

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
        NSLog(@"Missing elements in response");
#endif
        return nil;
    }

    Release *release = [[Release alloc] init];

    release.releaseId = [dictionary objectForKey:@"id"];
    release.title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"media"])
    {
        NSDictionary *media = [dictionary objectForKey:@"media"];

        if ([media objectForKey:@"disc-count"])
        {
            release.discCount = [media objectForKey:@"disc-count"];
        }
        if ([media objectForKey:@"format"])
        {
            release.format = [media objectForKey:@"format"];
        }
        if ([media objectForKey:@"ended"])
        {
            release.trackCount = [media objectForKey:@"track-count"];
        }
    }

    if ([dictionary objectForKey:@"score"])
    {
        release.score = [dictionary objectForKey:@"score"];
    }

    if ([dictionary objectForKey:@"country"])
    {
        release.country = [dictionary objectForKey:@"country"];
    }

    return release;
}

@end