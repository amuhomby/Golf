//
//  TripOrderController.m
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "TripOrderController.h"
#import "MKDropdownMenu.h"

@interface TripOrderController ()<UITextViewDelegate,
UITextFieldDelegate,
MKDropdownMenuDataSource, MKDropdownMenuDelegate,
FSCalendarDelegate, FSCalendarDataSource>
@property (nonatomic, retain) NSDateFormatter * formatter;
@end

@implementation TripOrderController
{
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;
    NSArray * arrTime;
    NSString * strTimeStart;
    NSString * strTimeEnd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard:)];
    gesture.numberOfTapsRequired = 1;
    _ScrolHeight = [UIScreen mainScreen].bounds.size.height - 60;
    [scrollView addGestureRecognizer:gesture];
    [self initData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self addDropDownMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initData{
    arrTime = [[NSArray alloc]initWithObjects:
               @"00:00",
               @"00:30",
               @"01:00",
               @"01:30",
               @"02:00",
               @"02:30",
               @"03:00",
               @"03:30",
               @"04:00",
               @"04:30",
               @"05:00",
               @"05:30",
               @"06:00",
               @"06:30",
               @"07:00",
               @"07:30",
               @"08:00",
               @"08:30",
               @"09:00",
               @"09:30",
               @"10:00",
               @"10:30",
               @"11:00",
               @"11:30",
               @"12:00",
               @"12:30",
               @"13:00",
               @"13:30",
               @"14:00",
               @"14:30",
               @"15:00",
               @"15:30",
               @"16:00",
               @"16:30",
               @"17:00",
               @"17:30",
               @"18:00",
               @"18:30",
               @"19:00",
               @"19:30",
               @"20:00",
               @"20:30",
               @"21:00",
               @"21:30",
               @"22:00",
               @"22:30",
               @"23:00",
               @"23:30",
               nil];
    
    strTimeStart = [arrTime objectAtIndex:0];
    strTimeEnd = [arrTime objectAtIndex:0];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"yyyy-MM-dd";
    
}
-(void) addDropDownMenu{
    CGRect rect1 = vwStartTime.frame;
    MKDropdownMenu *dropdownMenu = [[MKDropdownMenu alloc] initWithFrame:rect1];
    dropdownMenu.dataSource = self;
    dropdownMenu.delegate = self;
    dropdownMenu.dropdownBackgroundColor = mainTripBackColor;
    dropdownMenu.tag = 1;
    [scrollView addSubview:dropdownMenu];

    CGRect rect2 = vwEndTime.frame;
    MKDropdownMenu *dropdownMenu2 = [[MKDropdownMenu alloc] initWithFrame:rect2];
    dropdownMenu2.dataSource = self;
    dropdownMenu2.delegate = self;
    dropdownMenu2.dropdownBackgroundColor = mainTripBackColor;
    dropdownMenu2.tag = 2;
    [scrollView addSubview:dropdownMenu2];

}

- (void)removeKeyboard:(UIGestureRecognizer*)gr
{
    if ( _curEditingField != nil )
        [_curEditingField resignFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardDidShow:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if( kbSize.width < kbSize.height )
        _keyboardHeight = kbSize.width;
    else
        _keyboardHeight = kbSize.height;
    
    CGSize size = scrollView.frame.size;
    size.height = _ScrolHeight + _keyboardHeight;
    scrollView.contentSize = size;
    
    CGRect  contentRect = [scrollView convertRect:_curEditingField.bounds fromView:_curEditingField];
    contentRect.size.height += _keyboardHeight + 10;
    
    [scrollView scrollRectToVisible:contentRect animated:YES];
}

- (void)keyboardDidHide: (NSNotification *) notif
{
    CGSize size = scrollView.frame.size;
    size.height = _ScrolHeight;
    scrollView.contentSize = size;
    scrollView.contentOffset = CGPointMake(0, 0);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _curEditingField = textView;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _curEditingField = textField;
    return YES;
}

#pragma  mark DropDown Menu Delegate
- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu{
    return 1;
}
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component{
    return [arrTime count];
}


- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger tag = dropdownMenu.tag;
    [dropdownMenu closeAllComponentsAnimated:YES];
    if(tag == 1){
        strTimeStart = [arrTime objectAtIndex:row];
    }else{
        strTimeEnd = [arrTime objectAtIndex:row];
    }
    NSLog(@"%@", [arrTime objectAtIndex:row]);
    [dropdownMenu reloadAllComponents];
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [arrTime objectAtIndex:component];
}
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    NSInteger tag = dropdownMenu.tag;
    if(tag == 1){
        return [[NSAttributedString alloc] initWithString: strTimeStart
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightLight],
                                                            NSForegroundColorAttributeName: [UIColor blackColor]}];
    }else{
        return [[NSAttributedString alloc] initWithString: strTimeEnd
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightLight],
                                                            NSForegroundColorAttributeName: [UIColor blackColor]}];
    }
}
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component{
    NSInteger tag = dropdownMenu.tag;
    if(tag == 1){
        return [[NSAttributedString alloc] initWithString: strTimeStart
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightLight],
                                                            NSForegroundColorAttributeName: [UIColor blackColor]}];
    }else{
        return [[NSAttributedString alloc] initWithString: strTimeEnd
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightLight],
                                                            NSForegroundColorAttributeName: [UIColor blackColor]}];
    }

}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    NSString * str = [arrTime objectAtIndex:row];
    return [[NSAttributedString alloc] initWithString: str
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}


#pragma mark Calendar Delegate
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    // Do other updates here
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    lbData.text = [self.formatter stringFromDate:date];
    NSLog(@"did select %@",[self.formatter stringFromDate:date]);
}


#pragma mark Click
-(IBAction)ClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)ClickDate:(id)sender{
    vwCalendar.hidden = NO;
}

-(IBAction)ClickCalendar:(id)sender{
    vwCalendar.hidden = YES;
}
@end
