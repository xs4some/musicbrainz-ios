//
//  SearchService.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "SearchService.h"
#import "AppDelegate.h"
#import "Artist.h"
#import "Const.h"
#import "Label.h"
#import "Recording.h"
#import "Release.h"
#import "ReleaseGroup.h"
#import "Work.h"

@interface SearchService()

+(NSArray *)parseResultsWithJSON:(id)responseJSON;
+(NSArray *)parseArtistsWithArray:(NSArray *)array;
+(Artist *)parseArtistWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)parseLabelsWithArray:(NSArray *)array;
+(NSArray *)parseRecordingsWithArray:(NSArray *)array;
+(NSArray *)parseReleasesWithArray:(NSArray *)array;
+(NSArray *)parseReleaseGroupsWithArray:(NSArray *)array;
+(NSArray *)parseWorksWithArray:(NSArray *)array;

@end

@implementation SearchService

#define kWebServiceRoot @"http://musicbrainz.org/ws/2/"
#define kWebServiceAnnotation @"annotation"
#define kWebServiceArtist @"artist"
#define kWebServiceLabel @"label"
#define kWebServiceRecording @"recording"
#define kWebServiceRelease @"release"
#define kWebServiceReleaseGroup @"release-group"
#define kWebServiceWork @"work"

-(id)initServiceWithQuery:(NSDictionary *)query
{
    SearchType searchType = (SearchType)[[query objectForKey:@"searchType"] intValue];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[query objectForKey:@"params"]];

    NSString *serviceURL = nil;

    switch (searchType)
    {
        case SearchTypeArtist:
            serviceURL = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceArtist];
            break;

        case SearchTypeLabel:
            serviceURL = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceLabel];
            break;

        case SearchTypeRecording:
            serviceURL = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceRecording];
            break;

        case SearchTypeRelease:
            serviceURL = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceRelease];
            break;

        case SearchTypeReleaseGroup:
            serviceURL = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceReleaseGroup];
            break;

        case SearchTypeWork:
            serviceURL = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceWork];
            break;

        default:
            break;
    }

    self = [self initServiceWithURL:serviceURL params:params method:HTTPGET];

    return self;
}

-(void)getResultsOnCompletion:(void(^)(NSArray *results)) completionBlock onError:(MKNKErrorBlock)errorBlock
{
    [self addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
        if (![completedOperation isCachedResponse])
        {
            if (completedOperation.responseJSON) // only present on > iOS 5
            {
                completionBlock([SearchService parseResultsWithJSON:completedOperation.responseJSON]);
//            } else if (completedOperation.responseString) // iOS 4.3 fall back
//            {
                // TODO: add SBJSON to fallback on iOS 4.3
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        errorBlock(error);
    }];
    
    [ApplicationDelegate.network enqueueOperation:self forceReload:YES];
}

+(NSArray *)parseResultsWithJSON:(id)responseJSON
{
#if DEBUG
    NSLog(@"%@", responseJSON);
#endif

    if (![responseJSON isKindOfClass:[NSDictionary class]])
    {
        return [NSArray array];
    }

    if ([responseJSON objectForKey:@"artist"])
    {
        return [SearchService parseArtistsWithArray:[responseJSON objectForKey:@"artist"]];
    } else if ([responseJSON objectForKey:@"labels"])
    {
        return [SearchService parseLabelsWithArray:[responseJSON objectForKey:@"labels"]];
    } else  if ([responseJSON objectForKey:@"recording"])
    {
        return [SearchService parseRecordingsWithArray:[responseJSON objectForKey:@"recording"]];
    } else if ([responseJSON objectForKey:@"releases"])
    {
        return [SearchService parseReleasesWithArray:[responseJSON objectForKey:@"releases"]];
    } else if ([responseJSON objectForKey:@"release-group"])
    {
        return [SearchService parseReleaseGroupsWithArray:[responseJSON objectForKey:@"release-group"]];
    }  else if ([responseJSON objectForKey:@"work"])
    {
        return [SearchService parseWorksWithArray:[responseJSON objectForKey:@"work"]];
    }else
    {
        return [NSArray array];
    }
}

+(NSArray *)parseArtistsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Artist *artist = [SearchService parseArtistWithDictionary:dictionary];

        if (artist)
        {
            [results addObject:artist];
        }
    }

    return results;
}

+(Artist *)parseArtistWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"name"])
    {
#if DEBUG
        NSLog(@"Missing elements in response");
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

    return artist;
}

+(NSArray *)parseLabelsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"label"])
        {
#if DEBUG
            NSLog(@"Missing elements in response");
#endif
            continue;
        }

        Label *label = [[Label alloc] init];

        label.labelId = [dictionary objectForKey:@"id"];
        label.name = [dictionary objectForKey:@"name"];

        if ([dictionary objectForKey:@"life-span"])
        {
            NSDictionary *lifeSpan = [dictionary objectForKey:@"life-span"];

            if ([lifeSpan objectForKey:@"begin"])
            {
                label.lifeSpanBegin = [lifeSpan objectForKey:@"begin"];
            }
            if ([lifeSpan objectForKey:@"end"])
            {
                label.lifeSpanEnd = [lifeSpan objectForKey:@"end"];
            }
            if ([lifeSpan objectForKey:@"ended"])
            {
                NSNumber *lifeSpanEnded = [lifeSpan objectForKey:@"ended"];

                label.lifeSpanEnded = lifeSpanEnded.boolValue;
            }
        }

        if ([dictionary objectForKey:@"score"])
        {
            label.score = [dictionary objectForKey:@"score"];
        }

        if ([dictionary objectForKey:@"country"])
        {
            label.country = [dictionary objectForKey:@"country"];
        }

        [results addObject:label];
    }

    return results;
}

+(NSArray *)parseRecordingsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
        {
#if DEBUG
            NSLog(@"Missing elements in response");
#endif
            continue;
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

        [results addObject:recording];

        if ([dictionary objectForKey:@"releases"])
        {
            [SearchService parseReleasesWithArray:[dictionary objectForKey:@"releases"]];
        }
    }

    return results;
}

+(NSArray *)parseReleasesWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
        {
#if DEBUG
            NSLog(@"Missing elements in response");
#endif
            continue;
        }

        Release *release= [[Release alloc] init];

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

        [results addObject:release];
    }

    return results;
}

+(NSArray *)parseReleaseGroupsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
        {
#if DEBUG
            NSLog(@"Missing elements in response");
#endif
            continue;
        }

        ReleaseGroup *releaseGroup= [[ReleaseGroup alloc] init];

        releaseGroup.releaseGroupId = [dictionary objectForKey:@"id"];
        releaseGroup.title = [dictionary objectForKey:@"title"];

        if ([dictionary objectForKey:@"releases"])
        {
            releaseGroup.releases = [self parseReleasesWithArray:[dictionary objectForKey:@"releases"]];
        }

        if ([dictionary objectForKey:@"artist-credit"])
        {
            NSArray *artistCredit = [dictionary objectForKey:@"artist-credit"];
            if ([artistCredit count] > 0 )
            {
                NSDictionary *artist =  [artistCredit objectAtIndex:0];
                releaseGroup.artists = [self parseArtistWithDictionary:[artist objectForKey:@"artist"]];
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

        [results addObject:releaseGroup];
    }

    return results;
}

+(NSArray *)parseWorksWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
        {
#if DEBUG
            NSLog(@"Missing elements in response");
#endif
            continue;
        }

        Work *work = [[Work alloc] init];

        work.workId = [dictionary objectForKey:@"id"];
        work.title = [dictionary objectForKey:@"title"];

        if ([dictionary objectForKey:@"relations"])
        {
            NSArray *relations = [dictionary objectForKey:@"relations"];

            for (NSDictionary *relation in relations)
            {
                NSMutableArray *composers = [[NSMutableArray alloc] init];
                NSMutableArray *lyricists = [[NSMutableArray alloc] init];
                NSMutableArray *performers = [[NSMutableArray alloc] init];

                if ([relation objectForKey:@"artist"] && [relation objectForKey:@"type"])
                {
                   if ([[relation objectForKey:@"type"] isEqualToString:@"composer"])
                   {
                       Artist *artist = [self parseArtistWithDictionary:[relation objectForKey:@"artist"]];
                       [composers addObject:artist];
                   } else if ([[relation objectForKey:@"type"] isEqualToString:@"lyricsist"])
                   {
                       Artist *artist = [self parseArtistWithDictionary:[relation objectForKey:@"artist"]];
                       [lyricists addObject:artist];
                   } else if ([[relation objectForKey:@"type"] isEqualToString:@"performer"])
                   {
                       Artist *artist = [self parseArtistWithDictionary:[relation objectForKey:@"artist"]];
                       [performers addObject:artist];
                   }
                }

                work.composers = composers;
                work.lyricists = lyricists;
                work.performers = performers;
            }
        }

        if ([dictionary objectForKey:@"score"])
        {
            work.score = [dictionary objectForKey:@"score"];
        }

        [results addObject:work];
    }

    return results;
}

@end
