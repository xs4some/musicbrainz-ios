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