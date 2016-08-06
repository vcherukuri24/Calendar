//
//  EndDateAndTimeCell.h
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 FreJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EndDelegate <NSObject>

-(void)didEndDateSelected;
-(void)didEndTimeSelected;

@end

@interface EndDateAndTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *endDate;
@property (weak, nonatomic) IBOutlet UIButton *endTime;

@property(nonatomic,assign) id<EndDelegate>endDelegate;


@end
