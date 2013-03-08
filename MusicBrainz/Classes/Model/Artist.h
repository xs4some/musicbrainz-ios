//
//  Artist.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GenderMale,
    GenderFemale,
    GenderOther
} Gender;

typedef enum {
    ArtistTypePerson,
    ArtistTypeGroup
} ArtistType;

@interface Artist : NSObject

@property (nonatomic, retain) NSString *artistId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sortName;
@property (nonatomic, retain) NSString *disambiguation;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, assign) Gender *gender;
@property (nonatomic, assign) ArtistType *artistType;
@property (nonatomic, assign) NSNumber *score;
@property (nonatomic, retain) NSDate *lifeSpanBegin;
@property (nonatomic, retain) NSDate *lifeSpanEnd;
@property (nonatomic, assign) BOOL lifeSpanEnded;

@end
