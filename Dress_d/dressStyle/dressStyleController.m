//
//  dressStyleController.m
//  Strangrs
//
//  Created by MacAdmin on 9/6/17.
//  Copyright © 2017 AppDupe. All rights reserved.
//

#import "dressStyleController.h"
#import "dressAFGateController.h"
#import "StyleTableViewCell.h"

@interface dressStyleController ()

@end

@implementation dressStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self getStyleList];
}

-(void)viewDidLayoutSubviews{
    btnConti.layer.cornerRadius = btnConti.frame.size.height/2;
    btnConti.layer.masksToBounds = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)getStyleList{
    arrStyle = [[NSMutableArray alloc]init];
    arruserStyle = [[NSMutableArray alloc]init];

    NSDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * userid = [Global sharedGlobal].fbid;
    [params setValue:userid forKey:@"user_id"];
    [params setValue:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm getStyle:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrStyle = [result objectForKey:@"data"];
            arruserStyle = [result objectForKey:@"my_style"];
            
            [self showStyle];
//            [tbStyle reloadData];
        }else{
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:@"Server Error"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Retry"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                           [self getStyleList];
                                           
                                       }];
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                       }];
            
            [alert addAction:noButton];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    

}
-(void)showStyle{
    [self RemoveAllSubViews:viewStyle];
    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.25;
    CGFloat three =  [UIScreen mainScreen].bounds.size.width * 0.75;
    
    for(int i=0; i < [arrStyle count]; i++){
        NSMutableDictionary * rowDic = [arrStyle objectAtIndex:i];
        NSString * row = [rowDic objectForKey:@"name"];
        
        int b = i % 2;
        int a = (i - b)/2;
        
        CGRect fbtn = CGRectMake(0, 0, w, h);
        UIButton * btn = [[UIButton alloc]initWithFrame:fbtn];
        
        CGFloat x = 0, y= 0;
        
        if(b == 0){
            x = one;
        }else{
            x = three;
        }
        y = (gap + h) * (a + 1) - h/2;
        
        btn.center = CGPointMake(x, y);
        
        btn.layer.cornerRadius = h/2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 2;
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i;
        [btn addTarget:self action:@selector(addStyle:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:18];
        [btn setTitle:row forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [viewStyle addSubview:btn];
        btn.selected = NO;
        
        if([arruserStyle containsObject:rowDic])
        {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:mainGreenColor forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }
    
    CGFloat height =(floorf(([arrStyle count]+ 1) / 2)) * (gap + h) + gap;
    CGRect fbtncon = btnConti.frame;
    fbtncon.origin.y = height;
    UIButton * btnContinue = [[UIButton alloc]initWithFrame:fbtncon];
    CGPoint pbtncon = btnContinue.center;
    pbtncon.x = [UIScreen mainScreen].bounds.size.width/2;
    btnContinue.center = pbtncon;
    
    [btnContinue setTitle:@"Continue >" forState:UIControlStateNormal];
    btnContinue.titleLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:22];
    [btnContinue addTarget:nil action:@selector(onClickConti) forControlEvents:UIControlEventTouchUpInside];
//    [viewStyle addSubview:btnContinue];
    
    
    CGRect fvstyle = viewStyle.frame;
    fvstyle.size.height = height; //fbtncon.origin.y + fbtncon.size.height + gap;
    viewStyle.frame = fvstyle;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, fvstyle.origin.y + fvstyle.size.height);
}

-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrStyle count];
}
- (void)addStyle:(UIButton *)sender {
    
    [self showBusyDialog];
    [self performSelector:@selector(synch:) withObject:sender afterDelay:0.2];
}

-(void)synch:(UIButton *)sender{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    if(sender.selected){
        if([arruserStyle count] == 1){
            [self hideBusyDialog];

            return;
        }
        NSInteger index = sender.tag;
        [sender setBackgroundColor:UIColor.whiteColor];
        NSMutableDictionary * dicStyle = [arrStyle objectAtIndex:index];
        NSString * deselInterest = [NSString stringWithFormat:@"%@", [dicStyle objectForKey:@"id"]];
        [params setObject:deselInterest forKey:@"style_id"];
        NSDictionary * result = [UtilComm deleteuserstyle:params];
        [self hideBusyDialog];
        if(result != nil){
            NSDecimalNumber * deccode = [result objectForKey:@"code"];
            NSString * code = [NSString stringWithFormat:@"%@", deccode];
            if([code isEqualToString:@"1"]){
                [arruserStyle removeObject:dicStyle];
                sender.selected = NO;
                [self showStyle];
            }else{
                NSString * data = [result objectForKey:@"data"];
                [APPDELEGATE showToastMessage:data];
            }
        }else{
            [APPDELEGATE showToastMessage:CONNECT_ERROR];
        }
        
    }else{
        NSInteger count = [arruserStyle count];
        if(count >=3){
            [self hideBusyDialog];
            return;
        }
        
        NSInteger index = sender.tag;
        [sender setBackgroundColor:mainGreenColor];
        NSMutableDictionary * dicStyle = [arrStyle objectAtIndex:index];
        NSString * selInterest =[NSString stringWithFormat:@"%@",[dicStyle objectForKey:@"id"]];
        [params setObject:selInterest forKey:@"style_id"];
        NSDictionary * result = [UtilComm adduserstyle:params];
        [self hideBusyDialog];
        
        
        if(result != nil){
            NSDecimalNumber * deccode = [result objectForKey:@"code"];
            NSString * code = [NSString stringWithFormat:@"%@", deccode];
            if([code isEqualToString:@"1"]){
                [arruserStyle addObject:dicStyle];
                sender.selected = YES;
                [self showStyle];
            }else{
                NSString * data = [result objectForKey:@"data"];
                [APPDELEGATE showToastMessage:data];
            }
        }else{
            [APPDELEGATE showToastMessage:CONNECT_ERROR];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StyleTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"StyleTableViewCell" owner:self options:nil][0];
    
    NSMutableDictionary *rowDic = [arrStyle objectAtIndex:indexPath.row];
    NSString * row = [rowDic objectForKey:@"name"];
    //NSString * styleid =[NSString stringWithFormat:@"%@",[rowDic objectForKey:@"id"]];
    
    if([arruserStyle containsObject:rowDic])
    {
        cell.btnStyle.selected = YES;
        [cell.btnStyle setBackgroundColor:mainGreenColor];
    }
    
    [cell.btnStyle setTitle:row forState:UIControlStateNormal];
    cell.btnStyle.tag = indexPath.row;
    
    [cell.btnStyle addTarget:self action:@selector(addStyle:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h = 60;
    return h ;
    
}
-(IBAction)onClickNext:(id)sender{
    [self onClickConti];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickConti{
    NSInteger szStyle = [arruserStyle count];
    if(szStyle == 0){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Select Style."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }else{
        dressAFGateController * vc = [[dressAFGateController alloc] initWithNibName:@"dressAFGateController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
    }

}

@end
