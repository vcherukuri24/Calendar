//
//  StartDateAndTimeCell.m
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 FreJun. All rights reserved.
//

#import "StartDateAndTimeCell.h"

@implementation StartDateAndTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    NSString *dateString = [self curentDateStringFromDate:[NSDate date] withFormat:@"dd-MM-yy"];
    NSString *timeString = [self curentDateStringFromDate:[NSDate date] withFormat:@"hh:mm a"];

    
    [self.startDateButton setTitle:dateString forState:UIControlStateNormal];
    [self.startTimeButton setTitle:timeString forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)startDateButtonTapped:(id)sender {
    
    if([self.startDelegate respondsToSelector:@selector(didStartDateSeleceted)]){
        [self.startDelegate didStartDateSeleceted];
    }
    
}
- (IBAction)startTimeButtonTapped:(id)sender {
    
    
    if([self.startDelegate respondsToSelector:@selector(didStartTimeSelected)])
    {
        [self.startDelegate didStartTimeSelected];
    }
}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}

@end
