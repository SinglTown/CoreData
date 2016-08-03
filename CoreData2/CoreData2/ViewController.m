//
//  ViewController.m
//  CoreData2
//
//  Created by lanou3g on 15/12/15.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:app.managedObjectContext];
    p.name = @"zcb";
    //保存操作
    [app saveContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
