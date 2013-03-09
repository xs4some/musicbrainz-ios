//
//  ArtistService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "BasicService.h"
#import "Artist.h"

@interface ArtistService : BasicService

-(id)initServiceWithArtistId:(NSString *)artistId andParams:(NSMutableDictionary *)params;
-(void)getArtistOnCompletion:(void(^)(Artist *artist))completionBlock onError:(MKNKErrorBlock)errorBlock;
+(Artist *)artistWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)artistsWithArray:(NSArray *)array;

@end