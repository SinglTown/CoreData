//
//  ViewController.m
//  CoreData-Practice
//
//  Created by lanou3g on 15/12/15.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
@interface ViewController ()

@property (nonatomic,strong)NSManagedObjectContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建对象(描述实体模型)
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //2.桥梁
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //拼接存储路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"CoreData"];
    //连接路径
    NSDictionary *dict = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption:[NSNumber numberWithBool:YES]};
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:dict error:nil];
    //3.初始化上下文
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = storeCoordinator;
}
#pragma mark - 插入数据
- (IBAction)insertDataButton:(id)sender {
    
    NSInteger i = arc4random()%10;
    Person *aperson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.context];
    NSString *nameString = [NSString stringWithFormat:@"张%ld虎",i];
    aperson.name = nameString;
    NSInteger m = arc4random()%100;
    NSNumber *ageNumber = [NSNumber numberWithInteger:m];
    aperson.age = ageNumber;
    //并没有真正把aperson保存到数据库,而是暂时把它保存到context
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
    
}
#pragma mark - 查找所有
- (IBAction)selectAllDataButton:(id)sender {
    //创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        NSLog(@"%@,%@",per.name,per.age);
    }
}
#pragma mark - 根据条件查找
- (IBAction)searchByButton:(id)sender {
    //CoreData条件检索是通过谓词的方式
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like '*7*'"];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        NSLog(@"%@,%@",per.name,per.age);
    }
}
#pragma mark - 根据条件修改
- (IBAction)changeByButton:(id)sender {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age>=36"];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        per.name = @"傻逼";
    }
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
}
#pragma mark - 根据条件删除
- (IBAction)deleteByButton:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like '*傻逼*'"];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        [self.context deleteObject:per];
    }
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
}
#pragma mark - 删除所有
- (IBAction)deleteAllDataButton:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        [self.context deleteObject:per];
    }
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
