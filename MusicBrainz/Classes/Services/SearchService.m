//
//  SearchService.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "SearchService.h"

@implementation SearchService

#define kWebServiceRoot @"http://musicbrainz.org/ws/2/"
#define kWebServiceAnnotation @"annotation"
#define kWebServiceArtist @"artist"

-(id)initServiceForSearchWithAnnotation:(NSDictionary *)annotation
{
    NSString *serviceUrl = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceAnnotation];
    
    self = [self initServiceWithURL:serviceUrl params:nil method:HTTPGET];
    
    
    return self;
}

-(id)initServiceForSearchWithArtist:(NSDictionary *)dictionary
{
    NSString *serviceUrl = [NSString stringWithFormat:@"%@%@", kWebServiceRoot, kWebServiceArtist];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in dictionary)
    {
        if ([key isEqualToString:@"artist"])
        {
            NSString *artist = [NSString stringWithFormat:@"artist:%@", [dictionary objectForKey:@"artist"]];
            [params setObject:artist forKey:@"artist"];
        }
    }
    
//    arid	 MBID of the artist
//    artist	 name of the artist
//    artistaccent	 name of the artist with any accent characters retained
//    alias	 the aliases/misspellings for the artist
//    begin	 artist birth date/band founding date
//    comment	 artist comment to differentiate similar artists
//    country	 the two letter country code for the artist country or 'unknown'
//    end	 artist death date/band dissolution date
//        ended	 true if know ended even if do not know end date
//            gender	 gender of the artist (“male”, “female”, “other”)
//    ipi	 IPI code for the artist
//                    sortname	 artist sortname
//                    tag	 a tag applied to the artist
//                    type
    
    self = [self initServiceWithURL:serviceUrl params:params method:HTTPGET];
    
    return self;
}

@end
