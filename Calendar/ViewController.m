//
//  ViewController.m
//  Calendar
//
//  Created by Vivekananda Cherukuri on 06/08/2016.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import "ViewController.h"
#import "SACalendar.h"
#import "DateUtil.h"
#import "EventTitleCell.h"
#import "PullableView.h"
#import "CreateEventTableViewController.h"

@interface ViewController () <SACalendarDelegate,UITableViewDataSource,UITableViewDelegate,EventCreateDelegate,UIGestureRecognizerDelegate>
{
    SACalendar *saCalendar;
    PullableView *pullUpView;
    CGFloat tempHeight;
    
}

@property (weak, nonatomic) IBOutlet UIView *calendarBackGroundView;
@property (strong,nonatomic) NSMutableArray *taskArray;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    /*
     * Smooth scrolling in vertical direction
     * - to change to horizontal, change the scrollDirection to ScrollDirectionHorizontal
     * - to use paging scrolling, change pagingEnabled to YES
     * - to change the looks, please see documentation on Github
     * - the calendar works with any size
     */
    
    saCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 0, 320, 300)
                                      scrollDirection:ScrollDirectionVertical
                                        pagingEnabled:YES];
    saCalendar.delegate = self;
    [self.view addSubview:saCalendar];
    [self.view setBackgroundColor:[UIColor yellowColor]];

    tempHeight = saCalendar.bounds.size.height-20;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    pullUpView = [[PullableView alloc] initWithFrame:CGRectMake(0, 0, 375, 800)];
    pullUpView.openedCenter = CGPointMake(170,472);
    pullUpView.closedCenter = CGPointMake(170, 750);
    pullUpView.center = pullUpView.closedCenter;
    pullUpView.handleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    pullUpView.backgroundColor =[UIColor clearColor];
    
    [self.view addSubview:pullUpView];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)addEvent
{
    
    
    FJCreateEventTableViewController *fjcEvent = [[FJCreateEventTableViewController alloc]initWithNibName:@"CreateEventTableViewController" bundle:nil];
    fjcEvent.delegate = self;
    
    [self.navigationController presentViewController:fjcEvent animated:YES completion:nil];
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}



/**
 * Delegate method: get called when add event is tapped.
 */
-(void)didCreateEvent:(NSString*)taskName :(NSDate*)taskDate{
    
    // [self.taskArray addObject:taskName];
    [saCalendar removeFromSuperview];
    [self.view setNeedsDisplay];
    
    
    NSTimeInterval interval = [taskDate timeIntervalSinceDate:[NSDate date]];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]] ;
    localNotification.alertBody = taskName;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}


/**
 * Delegate method: get called when cancel event is tapped.
 */
-(void)didCancelTapped
{
    [saCalendar removeFromSuperview];
    
}

/**
 *  Delegate method : get called when a date is selected
 */
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    //NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}




@end

