
#import "DataSelectViewController.h"
#import "RadioBoxCell.h"

@implementation DataSelectViewController

+ (id)createWithDataList:(NSArray*)dataList selectIndex:(int)nSelIndex withTag:(int)tag
{
    DataSelectViewController* controller = [[DataSelectViewController alloc] initWithDataList:dataList selectIndex:nSelIndex withTag:tag];
    
    return controller;
}

- (id)initWithDataList:(NSArray*)dataList selectIndex:(int)nSelIndex withTag:(int)tag
{
    self = [self initWithNibName:@"DataSelectViewController" bundle:nil];
    
    _dataList = dataList;
    _nSelectedIdx = nSelIndex;
    _nTag = tag;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    tbleView.layer.cornerRadius = 5;

    /*
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTableView:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];*/
}

/*
- (void)tapOnTableView:(UITapGestureRecognizer *)gesture
{
    [self.view removeFromSuperview];
    [self release];
}*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect  rect = tbleView.frame;
    
    rect.size.height = 40*MIN(6, [_dataList count]);
    rect.origin.y = (self.view.frame.size.height - rect.size.height)/2;
    
    tbleView.frame = rect;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioBoxCell *cell;
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RadioBoxCell" owner:nil options:nil];
    cell = [arr objectAtIndex:0];

    cell.reasonLabel.text = [_dataList objectAtIndex:indexPath.row];
    
    UIImage *img;

    if( _nSelectedIdx == indexPath.row )
        img = [UIImage imageNamed:@"radio_sel.png"];
    else
        img = [UIImage imageNamed:@"radio_unsel.png"];
    
    cell.radioImgView = [cell.radioImgView initWithImage:img];

    return cell;
}

- (void)procTblSelectCell
{
    [self.view removeFromSuperview];
    
    if( [self.delegate respondsToSelector:@selector(DataSelectView:didSelectItem:withTag:)] )
        [self.delegate DataSelectView:self didSelectItem:(int)_nSelectedIdx withTag:(int)_nTag];
    
    //[createAccountView initSetting];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _nSelectedIdx = indexPath.row;
    [tableView reloadData];

    //createAccountView.selectedIdx = indexPath.row;

    [self performSelector:@selector(procTblSelectCell) withObject:nil afterDelay:0.2];
}

- (IBAction)onClickedCancel:(id)sender
{
    [self.view removeFromSuperview];
}

@end
