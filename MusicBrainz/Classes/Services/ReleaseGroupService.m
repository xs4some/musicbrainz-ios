//
//  ReleaseGroupService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "ReleaseGroupService.h"
#import "ArtistService.h"
#import "ReleaseService.h"

@implementation ReleaseGroupService

+(NSArray *)releaseGroupsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        ReleaseGroup *releaseGroup = [ReleaseGroupService releaseGroupWithDictionary:dictionary];

        if (releaseGroup)
        {
            [results addObject:releaseGroup];
        }
    }

    return results;
}

+(ReleaseGroup *)releaseGroupWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
    {
#if DEBUG
        NSLog(@"Missing elements in response");
#endif
        return nil;
    }

    ReleaseGroup *releaseGroup= [[ReleaseGroup alloc] init];

    releaseGroup.releaseGroupId = [dictionary objectForKey:@"id"];
    releaseGroup.title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"releases"])
    {
        releaseGroup.releases = [ReleaseService releasesWithArray:[dictionary objectForKey:@"releases"]];
    }

    if ([dictionary objectForKey:@"artist-credit"])
    {
        NSArray *artistCredit = [dictionary objectForKey:@"artist-credit"];
        if ([artistCredit count] > 0 )
        {
            NSDictionary *artist =  [artistCredit objectAtIndex:0];
            releaseGroup.artists = [ArtistService artistsWithArray:[artist objectForKey:@"artist"]];
        }
    }

    if ([dictionary objectForKey:@"count"])
    {
        releaseGroup.count = [dictionary objectForKey:@"count"];
    }

    if ([dictionary objectForKey:@"score"])
    {
        releaseGroup.score = [dictionary objectForKey:@"score"];
    }

    return releaseGroup;
}

@end