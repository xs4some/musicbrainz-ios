//
//  WorkService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "WorkService.h"
#import "ArtistService.h"

@implementation WorkService

+(NSArray *)worksWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Work *work = [WorkService workWithDictionary:dictionary];

        if (work)
        {
            [results addObject:work];
        }
    }

    return results;
}

+(Work *)workWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"title"])
    {
#if DEBUG
        NSLog(@"Work: Missing elements in response\n%@", dictionary);
#endif
        return nil;
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
                    Artist *artist = [ArtistService artistWithDictionary:[relation objectForKey:@"artist"]];
                    [composers addObject:artist];
                } else if ([[relation objectForKey:@"type"] isEqualToString:@"lyricsist"])
                {
                    Artist *artist = [ArtistService artistWithDictionary:[relation objectForKey:@"artist"]];
                    [lyricists addObject:artist];
                } else if ([[relation objectForKey:@"type"] isEqualToString:@"performer"])
                {
                    Artist *artist = [ArtistService artistWithDictionary:[relation objectForKey:@"artist"]];
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

    return work;
}

@end