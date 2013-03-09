//
//  SearchService.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "SearchService.h"
#import "AppDelegate.h"
#import "ArtistService.h"
#import "Const.h"
#import "RecordingService.h"
#import "LabelService.h"
#import "ReleaseService.h"
#import "ReleaseGroupService.h"
#import "WorkService.h"

@interface SearchService()

+(NSArray *)parseResultsWithJSON:(id)responseJSON;

@end

@implementation SearchService

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
        return [ArtistService artistsWithArray:[responseJSON objectForKey:@"artist"]];
    } else if ([responseJSON objectForKey:@"labels"])
    {
        return [LabelService parseLabelsWithArray:[responseJSON objectForKey:@"labels"]];
    } else  if ([responseJSON objectForKey:@"recording"])
    {
        return [RecordingService recordingsWithArray:[responseJSON objectForKey:@"recording"]];
    } else if ([responseJSON objectForKey:@"releases"])
    {
        return [ReleaseService releasesWithArray:[responseJSON objectForKey:@"releases"]];
    } else if ([responseJSON objectForKey:@"release-group"])
    {
        return [ReleaseGroupService releaseGroupsWithArray:[responseJSON objectForKey:@"release-group"]];
    }  else if ([responseJSON objectForKey:@"work"])
    {
        return [WorkService worksWithArray:[responseJSON objectForKey:@"work"]];
    }else
    {
        return [NSArray array];
    }
}

@end
