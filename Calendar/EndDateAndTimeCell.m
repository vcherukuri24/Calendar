//
//  EndDateAndTimeCell.m
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 FreJun. All rights reserved.
//

#import "EndDateAndTimeCell.h"

@implementation EndDateAndTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSString *dateString = [self curentDateStringFromDate:[NSDate date] withFormat:@"dd-MM-yy"];
    NSString *timeString = [self curentDateStringFromDate:[NSDate date] withFormat:@"hh:mm a"];

    [self.endDate setTitle:dateString forState:UIControlStateNormal];
    [self.endTime setTitle:timeString forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)endDateButtontTapped:(id)sender
{
 
    if([self.endDelegate respondsToSelector:@selector(didEndDateSelected)])
    {
      
        [self.endDelegate didEndDateSelected];
    }
}
- (IBAction)endTimeButtonTapped:(id)sender
{
    if([self.endDelegate respondsToSelector:@selector(didEndTimeSelected)])
    {
        
        [self.endDelegate didEndTimeSelected];
    }

}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}




@end
