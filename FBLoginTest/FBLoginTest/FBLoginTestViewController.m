//
//  FBLoginTestViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/3/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "FBLoginTestViewController.h"
#import "Friend.h"
#import "FriendsTableViewController.h"
#import "CheckPermissions.h"
#import "FBLoginTestAppDelegate.h"

@interface FBLoginTestViewController (){
    
    NSDictionary *dicForAPI;
}

@end

@implementation FBLoginTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loginDialog.readPermissions = @[@"basic_info", @"email", @"user_likes"];

    self.loginDialog.delegate = self;
    
    self.friendsContainer = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - FBLoginViewDelegate

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    self.profilePictureView.profileID = user.objectID;
    
    self.nameLabel.text = user.name;
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    self.statusLabel.text = @"Welcome back";
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    
    self.profilePictureView.profileID = nil;
    
    self.nameLabel.text = @"";
    
    self.statusLabel.text = @"Please login";
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    
    NSString *alertTitle, *alertMessage;
    
    if([FBErrorUtility shouldNotifyUserForError:error]){
        
        alertTitle = @"Facebook error";
        
        alertMessage = [FBErrorUtility userMessageForError:error];
        
    }else if([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
        
        alertTitle = @"Session Error";
        
        alertMessage = @"Your current session is no longer valid. Pleas log in again.";
        
    }else if([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled){
        
        NSLog(@"user cancelled login");
        
    }else{
        
        alertTitle = @"Something went wrong";
        
        alertMessage = @"Please try again later";
        
        NSLog(@"Unexpected error:%@", error);
        
    }
    
    if(alertMessage){
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
}

#pragma mark -
#pragma mark Pick friend
- (IBAction)pickFriend:(UIButton *)sender {
    
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    
    [self prepareForFriendPickerViewController:friendPickerController];
    
    [self showFriendPickerViewController:friendPickerController];
    
}

- (void)prepareForFriendPickerViewController:(FBFriendPickerViewController *)friendPickerController{
    
    [CheckPermissions checkForPermissions:@[@"friends_birthday"]];
    
    friendPickerController.title = @"Pick Friends";
    
    friendPickerController.fieldsForRequest = [NSSet setWithObject:@"birthday"];
    
    [friendPickerController loadData];
    
    [friendPickerController clearSelection];
}

- (void)showFriendPickerViewController:(FBFriendPickerViewController *)friendPickerController{
    
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         [self precessUserSelectionFromFriendPickerViewController:friendPickerController];
         
     }];
}

- (void)precessUserSelectionFromFriendPickerViewController:(FBFriendPickerViewController *)friendPickerController{
    NSString *message;
    
    self.friendsContainer = [NSMutableArray array];
    
    if (friendPickerController.selection.count == 0) {
        
        message = @"<No Friends Selected>";
        
    } else {
        
        NSMutableString *text = [[NSMutableString alloc] init];
        
        for (id<FBGraphUser> user in friendPickerController.selection) {
            if ([text length]) {
                [text appendString:@", "];
            }
            [text appendString:user.name];
            
            Friend *friend = [[Friend alloc]init];
            friend.firendName = user.name;
            friend.friendId = user.objectID;
            friend.friendBirthday = user.birthday;
            
            [self.friendsContainer addObject:friend];
        }
        message = text;
        [self performSegueWithIdentifier:@"ToTableView" sender:nil];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
    
}

#pragma mark -
#pragma mark Show all friends

- (IBAction)clickButton:(UIButton *)sender {
    
    [gAppDelegate startLoading];
    
    [CheckPermissions checkForPermissions:@[@"friends_birthday"]];
    
    dicForAPI = [[NSDictionary alloc] initWithObjects:@[@"me",@"friends",@[@"name",@"birthday"]] forKeys:@[@"node",@"edge",@"fields"]];
    
    [self callFBAPI];
    
}

- (void)callFBAPI{
    
    NSString *APIRequest = [self composeAPIRequestWithDicForAPI];
    
    [FBRequestConnection startWithGraphPath:APIRequest
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if(!error){
                                  
                                  [self parseFriendsData:result];
                                  
                                  [self performSegueWithIdentifier:@"ToTableView" sender:nil];
                              }
                          }];
    
}

- (NSString *)composeAPIRequestWithDicForAPI{
    
    NSString *node = [dicForAPI objectForKey:@"node"];
    
    NSString *edge = [dicForAPI objectForKey:@"edge"];
    
    NSMutableString *fields = [NSMutableString string];
    
    NSString *APIRequest;
    
    NSArray *fieldsArray = [dicForAPI objectForKey:@"fields"];
    
    for( NSString *field in fieldsArray ){
        
        if ([field isEqualToString:[fieldsArray lastObject]]){
            
            [fields appendString:field];
            
        }else{
            
            [fields appendFormat:@"%@,",field];
            
        }
    }
    
   return APIRequest = [NSString stringWithFormat:@"/%@/%@/?fields=%@",node,edge,fields];
}

- (void)parseFriendsData:(id)result{
    
    self.friendsContainer = [NSMutableArray array];
    
    
    NSArray *friends = [self parseResult:result];
    
    for(FBGraphObject<FBGraphUser> *data in friends){
        
        Friend *friend = [[Friend alloc] init];
        
        friend.firendName     = [data name];
        friend.friendBirthday = [data birthday];
        friend.friendId       = [data objectID];
        
        [self.friendsContainer addObject:friend];
    }
}

- (NSArray *)parseResult:(id)result{
    
    NSArray *data = [result objectForKey:@"data"];
    
    return data;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    FriendsTableViewController *tableView = (FriendsTableViewController *)segue.destinationViewController;
    tableView.friends = self.friendsContainer;
}
@end
