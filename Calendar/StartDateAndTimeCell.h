//
//  StartDateAndTimeCell.h
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 FreJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartDelegate <NSObject>

-(void)didStartDateSeleceted;
-(void)didStartTimeSelected;

@end

@interface StartDateAndTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;

@property(nonatomic,assign) id<StartDelegate>startDelegate;

@end
