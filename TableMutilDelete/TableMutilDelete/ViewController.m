//
//  ViewController.m
//  TableMutilDelete
//
//  Created by 林浩智 on 2014/11/14.
//  Copyright (c) 2014年 apc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController {
    NSMutableArray *dataSource;
    NSArray *toolbarItems;
    UIBarButtonItem *deleteButton;
    
    NSUInteger selectCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dataSource = [NSMutableArray arrayWithObjects:
                  @"東京", @"品川", @"新横浜", @"名古屋", @"京都", @"大阪", nil];
    
    selectCount = 0;
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView
{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEditTable)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // Create a button
    deleteButton = [[UIBarButtonItem alloc]
                    initWithTitle:@"Delete"
                    style:UIBarButtonItemStyleBordered
                    target:self
                    action:@selector(deleteRows)];
    [deleteButton setTintColor:[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1]];
    [deleteButton setEnabled:NO];
    
    toolbarItems = [[NSArray alloc] initWithObjects:deleteButton, nil];
    [self setToolbarItems:toolbarItems animated:YES];
}

//TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = dataSource[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //    if(indexPath.row == 2) {
    //        return NO;
    //    }
    
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isEditing] == YES) {
            [self updateSelectionCount];
        } else {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


-(void) startEditTable
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(stopEditTable)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void) stopEditTable
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEditTable)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView setEditing:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)updateSelectionCount
{
    selectCount = [[self.tableView indexPathsForSelectedRows] count];
    NSString *title = @"Delete";
    
    if (selectCount > 0) {
        title = [NSString stringWithFormat:@"%@ (%lu)", title, (unsigned long)selectCount];
    }
    
    deleteButton.enabled = (selectCount != 0);
    deleteButton.title = title;
}

- (void)deleteRows
{
    //「選択したセルたちのindexPath」が配列のかたちで取得できる
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows)
    {
        // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
        }
        // Delete the objects from our data model.
        [dataSource removeObjectsAtIndexes:indicesOfItemsToDelete];
        
        // Tell the tableView that we deleted the objects
        [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self stopEditTable];
    
    selectCount = 0;
}
@end
