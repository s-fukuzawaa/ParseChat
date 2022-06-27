//
//  ChatViewController.m
//  ParseChat
//
//  Created by Airei Fukuzawa on 6/27/22.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* messageArr;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchMessages) userInfo:nil repeats:true];
}
- (IBAction)sendButton:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_MU2022"];
    // Use the name of your outlet to get the text the user typed
        chatMessage[@"text"] = self.messageField.text;
    NSLog(@"%@", self.messageField.text);
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            [self fetchMessages];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    self.messageField.text = @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

- (void) fetchMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_MU2022"];
    [query orderByDescending:@"createdAt"];
//    [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            
            self.messageArr = posts;
            NSLog(@"%@", self.messageArr);
            [self.tableView reloadData];

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    PFObject *message = self.messageArr[indexPath.row];
    cell.message.text = message[@"text"];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
