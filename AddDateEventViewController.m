//
//  AddDateEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 24/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "AddDateEventViewController.h"

#define kTextFieldWidth	155
#define kTextFieldHeight 31


@implementation AddDateEventViewController


@synthesize wDaySelector,dateSelect,endDate,startDate,dateFormater,startHourLabel,endHourLabel,dtableView;


- (void)viewDidLoad {
	NSTimeInterval one_hour = 3600; 
	dateFormater = [[NSDateFormatter alloc] init];
	[dateFormater setPMSymbol:@"p.m."];
	[dateFormater setAMSymbol:@"a.m."];
	[dateFormater setDateStyle:NSDateFormatterShortStyle];
	[dateFormater setTimeStyle:NSDateFormatterShortStyle];
	startDate = [[NSDate alloc] init];
	[dateSelect setDate:startDate animated:NO];
	endDate =[[NSDate alloc] initWithTimeInterval:one_hour sinceDate:startDate]; 
	dtableView.scrollEnabled= NO;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
	[dtableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
	[self.dateSelect setDate:[NSDate date] animated:YES];
    
     
}

-(IBAction)done:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
//    if ([delegate respondsToSelector:@selector(addNoteEventViewController:didAddNoteEvent:)]) {
//        [delegate addNoteEventViewController:self didAddNoteEvent:noteTextView.text];
//    }
}


-(IBAction)cancel:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) dateChanged:(UIDatePicker *)sender{

		if (rowSelected == 0){
			
				[startDate release];
 				startDate = [[dateSelect date] retain];
				[self startDateFormater];
				endHourLabel.textColor = [self labelColor];
				startHourLabel.text = [dateFormater stringFromDate:startDate];		
	
		}
		
		else{
			
			[endDate release];
			endDate = [[dateSelect date] retain];
			NSComparisonResult startLaterThanEnd = [startDate compare:endDate];
			if (startLaterThanEnd == NSOrderedDescending)
				startHourLabel.textColor = [UIColor redColor];
			else
				startHourLabel.textColor = [UIColor blackColor];
			endHourLabel.text = [dateFormater stringFromDate:endDate];
			
		}
}

- (void) switchChange:(UISwitch *)sender{
	
	
	if (wDaySelector.on) {
		
		[self startDateFormater];
		// it's the same for ] both not neccesary to do this.
		//[self endDateFormater];
		NSString *endDateString = [dateFormater stringFromDate:endDate];
		NSString *startDateString = [dateFormater stringFromDate:startDate];
		startHourLabel.text = startDateString;
		endHourLabel.text = endDateString;
		dateSelect.datePickerMode = UIDatePickerModeDate;
	}
	
	else {
		
		[self startDateFormater];
		NSString *startDateString = [dateFormater stringFromDate:startDate];
		[self endDateFormater];
		NSString *endDateString = [dateFormater stringFromDate:endDate];
		startHourLabel.text = startDateString;
		endHourLabel.text = endDateString;
		dateSelect.datePickerMode = UIDatePickerModeDateAndTime;
	
	}
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	wDaySelector = nil;
	dateSelect = nil;
	startDate = nil;
	endDate = nil;
	dateFormater = nil;
	endHourLabel = nil;
	startHourLabel = nil;
	dtableView = nil;
//	rowSelected = nil;
}


- (void)dealloc {
	[wDaySelector release];
	[startHourLabel release];
	[endHourLabel release];
	[dateSelect release];
	[startDate release];
	[endDate release];
	[dateFormater release];
	[dtableView release];
	//[rowSelected release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	//rowSelected = indexPath;
	if (row == 0) {
		rowSelected = 0;
		[dateSelect setDate:startDate animated:YES];
	}
	else{	
		rowSelected = 1;
		[dateSelect setDate:endDate animated:YES];

	}
	
	
}


#pragma mark -
#pragma mark Table View dataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = nil;
	NSUInteger row = [indexPath row];
		
	if (row == 0) {
		
		static NSString *kstartDateCell_ID = @"startDateCell_ID";
		cell = [tableView dequeueReusableCellWithIdentifier:kstartDateCell_ID];
		
		if( cell == nil) {
		
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kstartDateCell_ID] autorelease];			
		}		

		[dtableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
		NSString *startDateString =[dateFormater stringFromDate:startDate]; 
		cell.textLabel.text = [NSString stringWithFormat:@"Starts"]; 
		UILabel *hLabel = [self initStartHourLabelWithHourString:startDateString];
		[cell.contentView addSubview:hLabel];
		
	}
	else if (row == 1) {
	
		static NSString *kendDateCell_ID = @"endDateCell_ID";
		cell = [tableView dequeueReusableCellWithIdentifier:kendDateCell_ID];
		if( cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kendDateCell_ID] autorelease];
		}
		[dateFormater setDateStyle:NSDateFormatterNoStyle];
		NSString *endDateString = [dateFormater stringFromDate:endDate];
		
		
		cell.textLabel.text = [NSString stringWithFormat:@"Ends"]; 
		UILabel *hLabel = [self initEndHourLabelWithHourString:endDateString];
		[cell.contentView addSubview:hLabel];
		
		}

	else{

		static NSString *kwholeDayCell_ID = @"wholeDayCell";
		cell = [tableView dequeueReusableCellWithIdentifier:kwholeDayCell_ID];

		if (cell == nil) {
			cell = [self getCellForWholeDay:kwholeDayCell_ID];
		}
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 3;
}

#pragma mark -
#pragma mark utility functions

- (UITableViewCell *) getCellForWholeDay:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 12, 120, 20);
	
	UILabel *lblTemp;
	UISwitch *switchTemp;
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.font = [UIFont boldSystemFontOfSize:16];
	lblTemp.text = @"Whole day";
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Switch
	switchTemp = self.wDaySelector;
	[cell.contentView addSubview:switchTemp];
	cell.accessoryView = wDaySelector;
	[(UISwitch *)cell.accessoryView setOn:NO];   
	
	
	

	return cell;
}

- (UISwitch *)wDaySelector{
	if (	wDaySelector == nil ) {
		
		CGRect SwitchFrame = CGRectMake(195, 9, 40, 40);
		wDaySelector = [[UISwitch alloc] initWithFrame:SwitchFrame];
		[wDaySelector addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
	}
	
	
	return wDaySelector;
}

- (UILabel *)initStartHourLabelWithHourString:(NSString *)string{
	if (startHourLabel == nil){
		CGRect frame = CGRectMake(135, 8, kTextFieldWidth, kTextFieldHeight);
		startHourLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		//	label.highlightedTextColor = [UIColor whiteColor];
		startHourLabel.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		startHourLabel.highlightedTextColor = [UIColor whiteColor];
		startHourLabel.textAlignment = UITextAlignmentRight;
		startHourLabel.font = [UIFont systemFontOfSize:18.0];
		startHourLabel.text = string;
		}
	return startHourLabel;
	
}


- (UILabel *)initEndHourLabelWithHourString:(NSString *)string{
		if (endHourLabel == nil){
			CGRect frame = CGRectMake(135, 8, kTextFieldWidth, kTextFieldHeight);
			endHourLabel = [[UILabel alloc] initWithFrame:frame];
		//	label.highlightedTextColor = [UIColor whiteColor];
			endHourLabel.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
			endHourLabel.highlightedTextColor = [UIColor whiteColor];
			endHourLabel.textAlignment = UITextAlignmentRight;
			endHourLabel.font = [UIFont systemFontOfSize:18.0];
			endHourLabel.text = string;
		}
		return endHourLabel;
}

- (void) startDateFormater{
	if (wDaySelector.on){
		
		[dateFormater setDateStyle:NSDateFormatterLongStyle];
		[dateFormater setTimeStyle:NSDateFormatterNoStyle];
		
	}
	else{
		[dateFormater setDateStyle:NSDateFormatterShortStyle];
		[dateFormater setTimeStyle:NSDateFormatterShortStyle];

	}
	
		
}

- (void) endDateFormater{
	
	if (wDaySelector.on){
		
		[dateFormater setDateStyle:NSDateFormatterLongStyle];
		[dateFormater setTimeStyle:NSDateFormatterNoStyle];
		
	}
	else{
	 
		[dateFormater setDateStyle:NSDateFormatterNoStyle];
		[dateFormater setTimeStyle:NSDateFormatterShortStyle];
	}
	
}

- (UIColor *) labelColor{
	
	NSComparisonResult startLaterThanEnd = [startDate compare:endDate];
	if (startLaterThanEnd == NSOrderedDescending){
		return [UIColor redColor];
		
	}
	else{
		return [UIColor blackColor];
	}
	
}

@end