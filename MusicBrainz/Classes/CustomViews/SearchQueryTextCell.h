//
//  SearchQueryTextCell.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 06-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchQueryTextCell;

@protocol SearchQueryTextCellDelegate <NSObject>

@optional

- (void)editDidFinish:(NSMutableDictionary *)result;

@end

@interface SearchQueryTextCell : UITableViewCell <SearchQueryTextCellDelegate>

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) id <UITextFieldDelegate> delegate;

@end
