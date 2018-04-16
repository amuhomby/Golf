//
//  DressSearchViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/15/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DressSearchViewController :ProgressViewController
{
    NSMutableArray * arrSend;
    NSMutableArray * arrReceive;
    
    NSMutableArray * arrAppFriend;
    NSMutableArray * arrFbFriend;
    NSMutableArray * arrFbShow;   // fb friend but not app friend
    
    NSMutableArray * arrSrhResult;
    
    
    NSString * searchWord;
    IBOutlet UIButton * btnBack;
    IBOutlet UIView * viewSrh;
    IBOutlet UITextField * tfSrh;
    IBOutlet UILabel * lbSen;
    IBOutlet UIView * vwBack;
    IBOutlet UITableView * tbPerson;
    IBOutlet UIButton * btnAdd;
    IBOutlet UIButton * btnPeople;
    IBOutlet UIButton * btnBrand;
    
    IBOutlet UIView * viewNo;
    IBOutlet UILabel * lbNo;
}
@end
