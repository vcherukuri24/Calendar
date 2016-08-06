//
//  EventNameCell.m
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 SyncoApp. All rights reserved.
//

#import "EventNameCell.h"

@interface EventNameCell()<UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;

@end


@implementation EventNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.eventNameTextField.delegate = self;
    // Initialization c
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    
    if([self.delegate respondsToSelector:@selector(didEndTypingText:)])
    {
        [self.delegate didEndTypingText:self.eventNameTextField.text];
    }
    
    [textField resignFirstResponder];
    
    return YES;

}



@end
