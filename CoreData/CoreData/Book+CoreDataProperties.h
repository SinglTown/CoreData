//
//  Book+CoreDataProperties.h
//  CoreData
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 chuanbao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Person *aperson;

@end

NS_ASSUME_NONNULL_END
