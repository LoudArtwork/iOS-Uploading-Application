//
//  SubscriptionViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-24.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "ArtworkIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface SubscriptionViewController () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
    NSString *_active;
}
@end

@implementation SubscriptionViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *bbid;
    // ---------- Get Business ID ---------- //
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:surveys];
        NSString *surveyResults = [[NSString alloc]initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
        bbid = surveyResults;
        [fileHandle closeFile];
    }
    // ---------- Get Business ID ---------- //
    
    // ---------- Get Business Info ---------- //
    NSString *post = [NSString stringWithFormat:@"b_id=%@",bbid];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laGetBusiness.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    // ---------- Get Business Info ---------- //

    _active = [NSString stringWithFormat:@"%@", [json objectForKey:@"act"]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [self.refreshControl beginRefreshing];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
}

- (void)reload {
    _products = nil;
    [self.tableView reloadData];
    [[ArtworkIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    
    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    if([_active isEqualToString:@"bronze"] && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else if([_active isEqualToString:@"silver"] && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else if([_active isEqualToString:@"silver"] && indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else if([_active isEqualToString:@"gold"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        if ([[ArtworkIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.accessoryView = nil;
        } else {
            UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            buyButton.frame = CGRectMake(0, 0, 72, 37);
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            buyButton.tag = indexPath.row;
            [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = buyButton;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[ArtworkIAPHelper sharedInstance] buyProduct:product];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
      
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}

- (IBAction)closeButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        [self performSegueWithIdentifier:@"SubToMenu" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"SubToInitial" sender:self];
    }
}

- (void)restoreTapped:(id)sender {
    [[ArtworkIAPHelper sharedInstance] restoreCompletedTransactions];
}
@end
