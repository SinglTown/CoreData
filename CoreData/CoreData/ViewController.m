//
//  ViewController.m
//  CoreData
//
//  Created by chuanbao on 15/12/15.
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
    NSLog(@"%@",NSHomeDirectory());
    
    //误区:coreData是数据库-->是不正确说法
    /*CoreData 05年 ios5之后发布,主要提供的是ORM功能(对象-关系映射),sqlite是关系型数据库
     coreData在存储数据的时候可以采取以下4种方式:数据库,XML文件,二进制形式,内存的形式(还有一种,自定义类型的形式),默认是采用数据库的存储方式
     
     
     CoreData苹果封装的一个工作在模型层的框架
     优势:1.可以直接存储OC对象,也可以把OC对象直接从以上四种存储文件中取出
         2.相对于数据库繁琐的SQL语句,CoreData不用再写SQL语句
    */
    //数据持久化技术:plist文件,NSUserDefaults,数据库,文件,CoreData
    
    
    //CoreData里面一些重要对象
    //1.NSManagedObjectContext 管理上下文,主要作用是:负责应用程序和数据之间的交互(CoreData任何实际的操作都是通过它来完成)
    //2.NSPersistentStoreCoordinator 连接器(桥梁)主要作用:决定coreData存储的方式,并且连接到具体存储的位置
    //3.NSManagedObject CoreData存取的直接对象
    //4.NSManagedObjectModel 模型实体类
    
    
    
    //1.创建一个NSManagedObjectModel对象(描述实体模型)
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //2.桥梁(连接器)
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //存储的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"data"];
    //连接路径
    //第一参数:存储的类型
    //第三个参数:路径
    //第四个参数:options-->版本迁移必须要填写
    NSError *error = nil;
    //第一个key值:自动迁移旧版本数据
    //第二个key值:自动匹配模型
    NSDictionary *dict = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption:[NSNumber numberWithBool:YES]};
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:dict error:&error];
    
    //3.初始化管理上下文
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //上下文管理 连接器
    self.context.persistentStoreCoordinator = storeCoordinator;
    
}
#pragma mark - 插入数据
- (IBAction)clickButtonAction:(id)sender {
    
    NSInteger i = arc4random()%100;
    Person *aPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.context];
    //通过KVC的方式赋值
    NSString *nameString = [NSString stringWithFormat:@"name%ld",i];
//    [aPerson setValue:nameString forKey:@"name"];
    aPerson.name = nameString;
    NSNumber *ageNumber = [NSNumber numberWithInteger:i];
//    [aPerson setValue:ageNumber forKey:@"age"];
    aPerson.age = ageNumber;
    //通过上面几步并没有真正把aperson保存到数据库,而是暂时把它保存到context里面
    //判断如果context发生了改变,则进行保存操作
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
}
#pragma mark - 查找所有
- (IBAction)searchButtonAction:(id)sender {
    //创建请求对象,并且指明所有的数据类型
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSArray *objcArray = [self.context executeFetchRequest:request error:nil];
    for (Person *per in objcArray) {
        NSLog(@"%@,%@",per.name,per.age);
    }
    
}
#pragma mark - 条件查找
- (IBAction)searchAgeButtonAction:(id)sender {
    //coreData 条件检索,是通过谓词的方式
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    //通过谓词去检索
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age>=20"];
    //检索name里面存在2的Person
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like '*2*'"];
    //把谓词条件赋值给需要检索的对象
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *p in array) {
        NSLog(@"%@,%@",p.name,p.age);
    }
}
#pragma mark - 修改
- (IBAction)updateClickButton:(id)sender {
    
    //把所有年龄大于65的Person的姓名改为老头
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age>65"];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        per.name = @"老头";
    }
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
}
#pragma mark - 删除
- (IBAction)deleteDataButton:(id)sender {
    
    //需求:删除年龄等于27的Person
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age=50"];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    if (array.count > 0) {
        for (Person *p in array) {
            //coreData执行删除操作
            [self.context deleteObject:p];
        }
    }
    //查看context是否改变,有得话保存
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
