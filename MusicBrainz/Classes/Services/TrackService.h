//
//  TrackService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"
#import "Track.h"

@interface TrackService : BasicService

+(NSArray *)tracksWithArray:(NSArray *)array;
+(Track *)trackWithDictionary:(NSDictionary *)dictionary;

@end