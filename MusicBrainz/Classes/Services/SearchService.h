//
//  SearchService.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"

@interface SearchService : BasicService

-(id)initServiceForSearchWithAnnotation:(NSDictionary *)annotation;
-(id)initServiceForSearchWithArtist:(NSDictionary *)artist;

@end
