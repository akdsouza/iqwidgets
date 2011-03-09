//
//  IQCalendarDataSource.m
//  IQWidgets
//
//  Created by Rickard Petzäll on 2011-03-09.
//  Copyright 2011 Jeppesen. All rights reserved.
//

#import "IQCalendarDataSource.h"


@implementation IQCalendarSimpleDataSource

+ (IQCalendarSimpleDataSource*) dataSourceWithSet:(NSSet*)items
{
    IQCalendarSimpleDataSource* ds = [[IQCalendarSimpleDataSource alloc] initWithSet:items];
    return [ds autorelease];
}

+ (IQCalendarSimpleDataSource*) dataSourceWithArray:(NSArray*)items
{
    IQCalendarSimpleDataSource* ds = [[IQCalendarSimpleDataSource alloc] initWithArray:items];
    return [ds autorelease];
}

- (id) initWithSet:(NSSet*)items
{
    self = [super init];
    if(self != nil) {
        data = [items retain];
    }
    return self;
}

- (id) initWithArray:(NSArray*)items
{
    self = [super init];
    if(self != nil) {
        data = [items retain];
    }
    return self;
}


#pragma mark Blocks

- (void) setCallbacksForStartDate:(IQCalendarDataSourceTimeExtractor)startDateCallback endDate:(IQCalendarDataSourceTimeExtractor)endDateCallback
{
    Block_release(startDateOfItem);
    Block_release(endDateOfItem);
    startDateOfItem = Block_copy(startDateCallback);
    endDateOfItem = Block_copy(endDateCallback);
}
- (void) setCallbackForText:(IQCalendarDataSourceTextExtractor)textCallback
{
    
    Block_release(textOfItem);
    textOfItem = Block_copy(textCallback);
}

#pragma mark Selectors

- (void) setSelectorsForStartDate:(SEL)startDateSelector endDate:(SEL)endDateSelector
{
    [self setCallbacksForStartDate:^(id item) {
        NSDate* date = [item performSelector:startDateSelector withObject:item];
        return [date timeIntervalSinceReferenceDate];
    } endDate:^(id item) {
        NSDate* date = [item performSelector:endDateSelector withObject:item];
        return [date timeIntervalSinceReferenceDate];
    }];
}

- (void) setSelectorForText:(SEL)textSelector
{
    [self setCallbackForText:^(id item) {
        return [item performSelector:textSelector withObject:item];
    }];
}

#pragma mark Key/value coding

- (void) setKeysForStartDate:(NSString*)startDateKey endDate:(NSString*)endDateKey
{
    [self setCallbacksForStartDate:^(id item) {
        NSDate* date = [item valueForKey:startDateKey];
        return [date timeIntervalSinceReferenceDate];
    } endDate:^(id item) {
        NSDate* date = [item valueForKey:endDateKey];
        return [date timeIntervalSinceReferenceDate];
    }];
}
- (void) setKeyForText:(NSString*)textKey
{
    [self setCallbackForText:^(id item) {
        return [item valueForKey:textKey];
    }];    
}

#pragma mark IQCalendarDataSource implementation

- (void) enumerateEntriesUsing:(IQCalendarDataSourceEntryCallback)enumerator from:(NSTimeInterval)startTime to:(NSTimeInterval)endTime
{
    if(startDateOfItem == nil || endDateOfItem == nil) {
        [self setSelectorsForStartDate:@selector(startDate) endDate:@selector(endDate)];
    }
    
    for(id item in (id<NSFastEnumeration>)data) {
        NSTimeInterval tstart = startDateOfItem(item);
        if(tstart < endTime) {
            NSTimeInterval tend = endDateOfItem(item);
            if(tend > startTime) {
                enumerator(item, tstart, tend);
            }
        }
    }
}

- (NSString*) textForItem:(id)item
{
    if(textOfItem == nil) {
        [self setSelectorForText:@selector(text)];
    }
    return textOfItem(item);
}

@end
