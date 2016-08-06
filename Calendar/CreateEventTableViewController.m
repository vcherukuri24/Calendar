//
//  FJCreateEventTableViewController.m
//  FreJun
//
//  Created by Vivekananda Cherukuri on 03/08/2016.
//  Copyright © 2016 SyncoApp. All rights reserved.
//

#import "CreateEventTableViewController.h"
#import "EventNameCell.h"
#import "AllDayEventCell.h"
#import "StartDateAndTimeCell.h"
#import "EndDateAndTimeCell.h"


@interface FJCreateEventTableViewController ()<UITableViewDelegate,UITableViewDataSource,StartDelegate,EndDelegate,EventNameDelegate>
{
    BOOL isStartDateReload;
    BOOL isEndDateReload;
    BOOL isStartTimeReload;
    BOOL isEndTimeReload;
    NSDate *eventStartDate;
    NSDate *eventStartTime;
    NSString *eventNameString;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *fjDatePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerBackgroundView;

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;

@end

@implementation FJCreateEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.datePickerBackgroundView.hidden = YES;
    isStartDateReload = NO;
    isEndDateReload = NO;
    
    eventStartDate = [[NSDate alloc]init];
    eventNameString = [[NSString alloc]init];
    eventStartTime = [[NSDate alloc]init];
    
     UINib *eventNameNib = [UINib nibWithNibName:@"EventNameCell" bundle:nil];
     UINib *allDayEventNib = [UINib nibWithNibName:@"AllDayEventCell" bundle:nil];
     UINib *startDateAnTimeNib = [UINib nibWithNibName:@"StartDateAndTimeCell" bundle:nil];
     UINib *endDateTimeNib = [UINib nibWithNibName:@"EndDateAndTimeCell" bundle:nil];
    
     [self.eventTableView registerNib:eventNameNib forCellReuseIdentifier:@"EventCell"];
     [self.eventTableView registerNib:allDayEventNib forCellReuseIdentifier:@"AllDayEventCell"];
     [self.eventTableView registerNib:startDateAnTimeNib forCellReuseIdentifier:@"StartDateAndTimeCell"];
     [self.eventTableView registerNib:endDateTimeNib forCellReuseIdentifier:@"EndDateAndTime"];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didStartDateSeleceted
{
    
    self.datePickerBackgroundView.hidden = NO;
    self.fjDatePicker.datePickerMode = UIDatePickerModeDate;
    isStartDateReload =YES;
    
    
}

-(void)didStartTimeSelected
{
    self.datePickerBackgroundView.hidden = NO;
    self.fjDatePicker.datePickerMode = UIDatePickerModeTime;
    isStartTimeReload = YES;
    
}


-(void)didEndDateSelected
{
    self.datePickerBackgroundView.hidden = NO;
    self.fjDatePicker.datePickerMode = UIDatePickerModeDate;
    isEndDateReload = YES;
}
-(void)didEndTimeSelected
{
    
    self.datePickerBackgroundView.hidden = NO;
    self.fjDatePicker.datePickerMode = UIDatePickerModeTime;
    isEndTimeReload = YES;
}


-(void)didEndTypingText:(NSString*)typedText
{
    eventNameString = typedText;
}



- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}


- (IBAction)addEventButtonTapped:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *defaultsArray = [[NSMutableArray alloc]init];
    
    
    NSMutableArray *taskArray = [[NSMutableArray alloc]init];
    
    taskArray = [[defaults objectForKey:@"EventStringArray"] mutableCopy];
    
    [taskArray addObject:eventNameString];
    
    [defaults setObject:taskArray forKey:@"EventStringArray"];
    
    
    defaultsArray = [[defaults objectForKey:@"FreJunTaskIndicatorArray"] mutableCopy];
    
    [defaultsArray addObject:eventStartDate];
    
    [defaults setObject:defaultsArray forKey:@"FreJunTaskIndicatorArray"];
    

    if([eventNameString isEqualToString:@""]){
        
        UIAlertView *fjerrorAlert = [[UIAlertView alloc]initWithTitle:@"FreJun" message:@"Task Field Empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [fjerrorAlert show];
        
    }
    else {
        
        if([self.delegate respondsToSelector:@selector(didCreateEvent::)]){
            
            [self.delegate didCreateEvent:eventNameString :eventStartTime];
        }
        
        UIAlertView *fjTaskAlert = [[UIAlertView alloc]initWithTitle:@"FreJun" message:@"Added Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [fjTaskAlert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}


- (IBAction)cancelEventPageButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if([self.delegate respondsToSelector:@selector(didCancelTapped)])
    {
        [self.delegate didCancelTapped];
    }
    
}

- (IBAction)cancelButtonTapped:(id)sender
{
    
    self.datePickerBackgroundView.hidden = YES;
}

- (IBAction)donButtonTapped:(id)sender
{
    if(isStartDateReload)
    {
        eventStartDate = self.fjDatePicker.date;
    }
    
    else if (isStartTimeReload)
    {
        eventStartTime = self.fjDatePicker.date;
    }
    self.datePickerBackgroundView.hidden = YES;
    [self.eventTableView reloadData];
    
   }




/*
 *TableView delegate meyhods:
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventNameCell *eventNameCell;
    AllDayEventCell *allDayEventCell;
    StartDateAndTimeCell *startDateAndTimeCell;
    EndDateAndTimeCell *endDateAndTimeCell;
    
    
    if(indexPath.row == 0)
    {
        eventNameCell = (EventNameCell *)[self.eventTableView  dequeueReusableCellWithIdentifier:@"EventCell"];
        eventNameCell.delegate = self;
        return  eventNameCell;
    }
    
    else if (indexPath.row == 1)
    {
        return  allDayEventCell  = (AllDayEventCell*)[self.eventTableView dequeueReusableCellWithIdentifier:@"AllDayEventCell"];
        
    }
    
    else if ( indexPath.row == 2)
    {
        
        startDateAndTimeCell = (StartDateAndTimeCell*)[self.eventTableView dequeueReusableCellWithIdentifier:@"StartDateAndTimeCell"];
        startDateAndTimeCell.startDelegate = self;
        
        if(isStartDateReload == YES)
        {
            NSString *dateString = [self curentDateStringFromDate:_fjDatePicker.date withFormat:@"dd-MM-yy"];
            
            [startDateAndTimeCell.startDateButton setTitle:dateString forState:UIControlStateNormal];
            isStartDateReload = NO;
        }
        
        else if ( isStartTimeReload)
        {
            NSString *timeString = [self curentDateStringFromDate:_fjDatePicker.date withFormat:@"hh:mm a"];
            
            [startDateAndTimeCell.startTimeButton setTitle:timeString forState:UIControlStateNormal];
            isStartTimeReload = NO;
        }
        
        
        return startDateAndTimeCell;
    }
    
    else{
        
        endDateAndTimeCell = (EndDateAndTimeCell*)[self.eventTableView dequeueReusableCellWithIdentifier:@"EndDateAndTime"];
        endDateAndTimeCell.endDelegate = self;
        
        if(isEndDateReload == YES)
        {
            NSString *dateString = [self curentDateStringFromDate:_fjDatePicker.date withFormat:@"dd-MM-yy"];
            [endDateAndTimeCell.endDate setTitle:dateString forState:UIControlStateNormal];
            isEndDateReload = NO;
        }
        
        else if (isEndTimeReload)
        {
            NSString *timeString = [self curentDateStringFromDate:_fjDatePicker.date withFormat:@"hh:mm a"];
            [endDateAndTimeCell.endTime setTitle:timeString forState:UIControlStateNormal];
            isEndTimeReload = NO;
            
        }
        
        
        return  endDateAndTimeCell;
    }
    
    
}



@end
