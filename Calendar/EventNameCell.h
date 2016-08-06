//
//  EventNameCell.h
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 SyncoApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventNameDelegate <NSObject>

-(void)didEndTypingText:(NSString*)typedText;

@end

@interface EventNameCell : UITableViewCell

@property(nonatomic,assign) id<EventNameDelegate>delegate;


@end
