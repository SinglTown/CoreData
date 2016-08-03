//
//  Student+CoreDataProperties.h
//  CoreData-Practice
//
//  Created by lanou3g on 15/12/15.
//  Copyright © 2015年 chuanbao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Person *aperson;

@end

NS_ASSUME_NONNULL_END
