//
//  MediumService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "MediumService.h"
#import "TrackService.h"


@implementation MediumService

+(NSArray *)mediaWithArray:(NSArray *)array
{
    NSMutableArray *media = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Medium *medium = [MediumService mediumWithDictionary:dictionary];

        if (medium)
        {
            [media addObject:medium];
        }
    }

    return media;
}

+(Medium *)mediumWithDictionary:(NSDictionary *)dictionary
{
    Medium *medium = [[Medium alloc] init];

    if ([dictionary objectForKey:@"format"])
    {
        medium.format = [dictionary objectForKey:@"format"];
    }

    if ([dictionary objectForKey:@"track-count"])
    {
        medium.trackCount = [dictionary objectForKey:@"track-count"];
    }

    if ([dictionary objectForKey:@"tracks"])
    {
        medium.tracks = [TrackService tracksWithArray:[dictionary objectForKey:@"tracks"]];
    }

    return medium;
}

@end