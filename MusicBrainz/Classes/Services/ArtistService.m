//
//  ArtistService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "ArtistService.h"
#import "Const.h"
#import "AppDelegate.h"
#import "RecordingService.h"
#import "ReleaseService.h"
#import "ReleaseGroupService.h"
#import "WorkService.h"

@interface ArtistService ()

@end

@implementation ArtistService

-(id)initServiceWithArtistId:(NSString *)artistId andParams:(NSMutableDictionary *)params
{
    if (params == nil)
    {
        params = [NSMutableDictionary dictionaryWithDictionary: @{@"inc":@"recordings+releases+release-groups+works"}];
    }
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@/%@", kWebServiceRoot, kWebServiceArtist, artistId];

    self = [self initServiceWithURL:serviceURL params:params method:HTTPGET];

    return self;
}

-(void)getArtistOnCompletion:(void(^)(Artist *artist))completionBlock onError:(MKNKErrorBlock)errorBlock
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
                    completionBlock([ArtistService artistWithDictionary:completedOperation.responseJSON]);
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

+(NSArray *)artistsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Artist *artist = [ArtistService artistWithDictionary:dictionary];

        if (artist)
        {
            [results addObject:artist];
        }
    }

    return results;
}

+(Artist *)artistWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"name"])
    {
#if DEBUG
        NSLog(@"artist: Missing elements in response\n%@", dictionary);
#endif
        return nil;
    }

    Artist *artist = [[Artist alloc] init];

    artist.artistId = [dictionary objectForKey:@"id"];
    artist.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"disambiguation"])
    {
        artist.disambiguation = [dictionary objectForKey:@"disambiguation"];
    }

    if ([dictionary objectForKey:@"life-span"])
    {
        NSDictionary *lifeSpan = [dictionary objectForKey:@"life-span"];

        if ([lifeSpan objectForKey:@"begin"])
        {
            artist.lifeSpanBegin = [lifeSpan objectForKey:@"begin"];
        }
        if ([lifeSpan objectForKey:@"end"])
        {
            artist.lifeSpanEnd = [lifeSpan objectForKey:@"end"];
        }
        if ([lifeSpan objectForKey:@"ended"])
        {
            NSNumber *lifeSpanEnded = [lifeSpan objectForKey:@"ended"];

            artist.lifeSpanEnded = lifeSpanEnded.boolValue;
        }
    }

    if ([dictionary objectForKey:@"score"])
    {
        artist.score = [dictionary objectForKey:@"score"];
    }

    if ([dictionary objectForKey:@"country"])
    {
        artist.country = [dictionary objectForKey:@"country"];
    }

    if ([dictionary objectForKey:@"recordings"])
    {
        artist.recordings = [RecordingService recordingsWithArray:[dictionary objectForKey:@"recordings"]];
    }

    if ([dictionary objectForKey:@"releases"])
    {
        artist.recordings = [ReleaseService releasesWithArray:[dictionary objectForKey:@"releases"]];
    }

    if ([dictionary objectForKey:@"release-groups"])
    {
        artist.releaseGroups = [ReleaseGroupService releaseGroupsWithArray:[dictionary objectForKey:@"release-groups"]];
    }

    if ([dictionary objectForKey:@"works"])
    {
        artist.works = [WorkService worksWithArray:[dictionary objectForKey:@"works"]];
    }

    return artist;
}

@end