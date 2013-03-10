//
//  RecordingService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "RecordingService.h"
#import "Recording.h"
#import "SearchService.h"
#import "ReleaseService.h"

@implementation RecordingService

-(id)initServiceWithRecordingId:(NSString *)recordingId andParams:(NSMutableDictionary *)params
{

}

+(NSArray *)recordingsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Recording *recording = [RecordingService recordingWithDictionary:dictionary];

        if (recording)
        {
            [results addObject:recording];
        }
    }

    return results;
}

+(Recording *)recordingWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
    {
#if DEBUG
        NSLog(@"recording: Missing elements in response\n%@", dictionary);
#endif
        return nil;
    }

    Recording *recording = [[Recording alloc] init];

    recording.recordingId = [dictionary objectForKey:@"id"];
    recording.title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"score"])
    {
        recording.score = [dictionary objectForKey:@"score"];
    }

    if ([dictionary objectForKey:@"country"])
    {
        recording.country = [dictionary objectForKey:@"country"];
    }

    if ([dictionary objectForKey:@"releases"])
    {
        recording.releases = [ReleaseService releasesWithArray:[dictionary objectForKey:@"releases"]];
    }

    return recording;
}

@end