
#import <UIKit/UIKit.h>

@class  DataSelectViewController;

@protocol DataSelectViewDelegate <NSObject>

@optional

- (void)DataSelectView:(DataSelectViewController*)dataSelectView didSelectItem:(int)itemIndex withTag:(int)tag;

@end

@interface DataSelectViewController :  UIViewController<UITableViewDataSource, UITableViewDelegate>

{
    IBOutlet UITableView    *tbleView;
    
    NSInteger   _nTag;
    NSInteger   _nSelectedIdx;
    NSArray*    _dataList;
}

+ (id)createWithDataList:(NSArray*)dataList selectIndex:(int)nSelIndex withTag:(int)tag;

@property (nonatomic, assign) id<DataSelectViewDelegate> delegate;

- (IBAction)onClickedCancel:(id)sender;

@end
