//
//  FJCreateEventTableViewController.h
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 SyncoApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventCreateDelegate <NSObject>

-(void)didCreateEvent:(NSString*)taskName :(NSDate*)taskDate;

-(void)didCancelTapped;

@end


@interface FJCreateEventTableViewController : UIViewController

@property(nonatomic,weak)id<EventCreateDelegate>delegate;



@end
