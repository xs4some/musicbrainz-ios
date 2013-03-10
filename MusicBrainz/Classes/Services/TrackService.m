//
//  TrackService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "TrackService.h"
#import "RecordingService.h"
#import "ArtistService.h"

@implementation TrackService

+(NSArray *)tracksWithArray:(NSArray *)array
{
    NSMutableArray *tracks = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Track *track = [TrackService trackWithDictionary:dictionary];

        if (track)
        {
            [tracks addObject:track];
        }
    }

    return tracks;
}

+(Track *)trackWithDictionary:(NSDictionary *)dictionary
{
    Track *track = [[Track alloc] init];

    if (![dictionary objectForKey:@"title"] ||
            ![dictionary objectForKey:@"number"])
    {
#if DEBUG
        NSLog(@"Track: Missing elements in response\n%@", dictionary);
#endif
        return nil;
    }

    track.title = [dictionary objectForKey:@"title"];
    track.number = [dictionary objectForKey:@"number"];

    if ([dictionary objectForKey:@"length"])
    {
        track.length = [dictionary objectForKey:@"length"];
    }

    if ([dictionary objectForKey:@"recording"])
    {
        track.recording = [RecordingService recordingWithDictionary:@"recording"];
    }

    if ([dictionary objectForKey:@"artist-credit"])
    {
        track.artists = [ArtistService artistsWithArray:[dictionary objectForKey:@"artist-credit"]];
    }

    return track;
}

@end