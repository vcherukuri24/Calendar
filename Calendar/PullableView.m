
#import "PullableView.h"


/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation PullableView
{
     NSMutableArray *sectionTitleArray;
     NSMutableArray *taskArray;
     NSMutableArray *eventDateArray;
     NSMutableArray *mainArray;
    
     UITableView *eventNameTableView;
     NSUserDefaults *frejunDefaults;
}



@synthesize handleView;
@synthesize closedCenter;
@synthesize openedCenter;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate;
@synthesize opened;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        taskArray         = [[NSMutableArray alloc]init];
        eventDateArray    = [[NSMutableArray alloc]init];
        sectionTitleArray = [[NSMutableArray alloc]init];
        mainArray         = [[NSMutableArray alloc]init];
        
        frejunDefaults    = [NSUserDefaults standardUserDefaults];

     //populating array with all the dates which belong to events.
        for(id date in [frejunDefaults objectForKey:@"FreJunTaskIndicatorArray"])
        {
            
            NSString *dateString = [self curentDateStringFromDate:date withFormat:@"dd-MM-yyyy"];
            [eventDateArray addObject:dateString];
            
        }
        

        for (id obj in eventDateArray)
        {
            if (![sectionTitleArray containsObject:obj]) {
                
                [sectionTitleArray addObject:obj];
            }
            
            
        }
        
        for(NSString *taskName in [frejunDefaults objectForKey:@"EventStringArray"])
        {
            [taskArray addObject:taskName];

        }
        
        for(id obj in sectionTitleArray){
            
            NSMutableArray *newArray = [[NSMutableArray alloc]init];
            
            for(int i = 0; i<[eventDateArray count];i++)
            {
                
                if([obj isEqualToString:[eventDateArray objectAtIndex:i]])
                {
                    [newArray addObject:[taskArray objectAtIndex:i]];
                }
            }
            
            [mainArray addObject:newArray];
        }
      
        
        eventNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 330, self.frame.size.height)];
        eventNameTableView.dataSource = self;
        eventNameTableView.delegate = self;
        [self addSubview:eventNameTableView];
        
        animate = YES;
        animationDuration = 0.2;
        
        toggleOnTap = YES;
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
        [self addSubview:handleView];
        
        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        dragRecognizer.minimumNumberOfTouches = 1;
        dragRecognizer.maximumNumberOfTouches = 1;
        
        [handleView addGestureRecognizer:dragRecognizer];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [handleView addGestureRecognizer:tapRecognizer];
        
        opened = NO;
    }
    return self;
}

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        startPos = self.center;
        
        // Determines if the view can be pulled in the x or y axis
        verticalAxis = closedCenter.x == openedCenter.x;
        
        // Finds the minimum and maximum points in the axis
        if (verticalAxis) {
            minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter;
            maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter;
        } else {
            minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
            maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
        }
        
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
                
        CGPoint translate = [sender translationInView:self.superview];
        
        CGPoint newPos;
        
        // Moves the view, keeping it constrained between openedCenter and closedCenter
        if (verticalAxis) {
            
            newPos = CGPointMake(startPos.x, startPos.y + translate.y);
            
            if (newPos.y < minPos.y) {
                newPos.y = minPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
            }
            
            if (newPos.y > maxPos.y) {
                newPos.y = maxPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
            }
        } else {
            
            newPos = CGPointMake(startPos.x + translate.x, startPos.y);
            
            if (newPos.x < minPos.x) {
                newPos.x = minPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
            
            if (newPos.x > maxPos.x) {
                newPos.x = maxPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
        }
        
        [sender setTranslation:translate inView:self.superview];
        
        self.center = newPos;
        
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // Gets the velocity of the gesture in the axis, so it can be
        // determined to which endpoint the state should be set.
        
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x;
        
        CGPoint target = axisVelocity < 0 ? minPos : maxPos;
        BOOL op = CGPointEqualToPoint(target, openedCenter);
        
        [self setOpened:op animated:animate];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self setOpened:!opened animated:animate];
    }
}

- (void)setToggleOnTap:(BOOL)tap {
    toggleOnTap = tap;
    tapRecognizer.enabled = tap;
}

- (BOOL)toggleOnTap {
    return toggleOnTap;
}

- (void)setOpened:(BOOL)op animated:(BOOL)anim {
    opened = op;
    
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    self.center = opened ? openedCenter : closedCenter;
    
    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        dragRecognizer.enabled = NO;
        tapRecognizer.enabled = NO;
        
        [UIView commitAnimations];
        
    } else {
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}
         
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}

//TableViewDataSource.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return  [sectionTitleArray count];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1]];
    [headerView addSubview:myLabel];
    
    return headerView;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if([sectionTitleArray count])
    {
        return [sectionTitleArray objectAtIndex:section];
        
    }
    else
    {
        return @"";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *rowArray = [[NSMutableArray alloc]init];
    
    int sectionIndex = (int)section;
    
    for(int i = sectionIndex; i<[sectionTitleArray count];i++ )
    {
        [rowArray removeAllObjects];
        
        for(id rowObj in eventDateArray)
        {
            
            if([[sectionTitleArray objectAtIndex:i] isEqualToString:rowObj])
            {
                
                [rowArray addObject:rowObj];
            }
        }
        
        return [rowArray count];
        
    }
    
    return  [rowArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [[mainArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return  cell;
    
}


//TableViewDataSource.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    UITableViewCell *selectedCell = [eventNameTableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[[mainArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        selectedCell.textLabel.attributedText =attributeString;
    }
    else
        if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[[mainArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
            [attributeString addAttribute:NSStrokeColorAttributeName
                                    value:[UIColor redColor]
                                    range:NSMakeRange(0, [attributeString length])];
            selectedCell.textLabel.attributedText =attributeString;
            
        }
    
    
   

}





@end
