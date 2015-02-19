//
//  subScreen.m
//  UDCSiOSApp4
//
//  Created by WL on 13-10-4.
//  Copyright (c) 2013年 WL. All rights reserved.
//

#import "subScreen.h"



@interface subScreen ()
@property (weak, nonatomic) IBOutlet UILabel *lbIMEI;
@property (weak, nonatomic) IBOutlet UILabel *lbLicenseStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbLicenseString;
@property (weak, nonatomic) IBOutlet UITextField *txtNewLicense;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleRefreshLicense;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleHardwareInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbHardwareCode;
@property (weak, nonatomic) IBOutlet UILabel *lbLicenseManagement;
@property (weak, nonatomic) IBOutlet UILabel *lbLicenseCode;
@property (weak, nonatomic) IBOutlet UIButton *btnRefreshLicense;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveLicense;
- (IBAction)RefreshtxtLicense:(id)sender;
- (IBAction)SaveNewLicense:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundTap:(id)sender; //通过触摸背景关闭键盘

@end

@implementation subScreen
//按完Done键以后关闭键盘

- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
//通过触摸背景关闭键盘

- (IBAction) backgroundTap:(id)sender
{
    [self.txtNewLicense resignFirstResponder];
    //[numberField resignFirstResponder];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self openDataBase];
    self.lbIMEI.text=[self getHardWareString];
    self.lbLicenseString.text=[self getLicense];
    NSString* LicenseStatus=[self CheckLicense:self.lbLicenseString.text];
    self.lbLicenseStatus.text=LicenseStatus;
    //适应ios6
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *MajorVersion=[systemVersion substringToIndex:1];
    //self.lbToken.text=[NSString stringWithFormat:@"%@",MajorVersion];
    NSInteger intOffset=60;
    if ([MajorVersion isEqualToString:@"6"]) {
//        @property (weak, nonatomic) IBOutlet UILabel *lbIMEI;
//        @property (weak, nonatomic) IBOutlet UILabel *lbLicenseStatus;
//        @property (weak, nonatomic) IBOutlet UILabel *lbLicenseString;
//        @property (weak, nonatomic) IBOutlet UITextField *txtNewLicense;
//        @property (weak, nonatomic) IBOutlet UILabel *lbTitleRefreshLicense;
//        @property (weak, nonatomic) IBOutlet UILabel *lbTitleHardwareInfo;
//        @property (weak, nonatomic) IBOutlet UILabel *lbHardwareCode;
//        @property (weak, nonatomic) IBOutlet UILabel *lbLicenseManagement;
//        @property (weak, nonatomic) IBOutlet UILabel *lbLicenseCode;
//        @property (weak, nonatomic) IBOutlet UIButton *btnRefreshLicense;
//        @property (weak, nonatomic) IBOutlet UIButton *btnSaveLicense;
        [self.lbIMEI setFrame:CGRectMake(87, 136,233,21)];
        [self.lbLicenseStatus setFrame:CGRectMake(0, 251+intOffset,320,21)];
        [self.lbLicenseString setFrame:CGRectMake(0, 300+intOffset,320,27)];
        [self.txtNewLicense setFrame:CGRectMake(0, 94+intOffset,320,30)];
        [self.lbTitleRefreshLicense setFrame:CGRectMake(0, 65+intOffset,320,21)];
        [self.lbTitleHardwareInfo setFrame:CGRectMake(0, 170+intOffset,320,21)];
        [self.lbHardwareCode setFrame:CGRectMake(0, 196+intOffset,85,21)];
        [self.lbLicenseManagement setFrame:CGRectMake(0, 227+intOffset,320,21)];
        [self.lbLicenseCode setFrame:CGRectMake(0, 280+intOffset,51,21)];
        [self.btnRefreshLicense setFrame:CGRectMake(0, 132+intOffset,85,30)];
        [self.btnSaveLicense setFrame:CGRectMake(235, 132+intOffset,85,30)];
        
    }
    
}

//open database
-(BOOL) openDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"udcsiosappdb.sqlite3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    
    //找到数据库文件mydb.sql
    if (find) {
        NSLog(@"Database file have already existed.");
        if(sqlite3_open([path UTF8String], &database_) != SQLITE_OK) {
            sqlite3_close(database_);
            NSLog(@"Error: open database file.");
            return NO;
        }
        return YES;
    }
    return NO;
}

-(NSString *)getLicense
{
    NSString *sqlQuery = @"SELECT LicenseString FROM AppLicense where idAppLicense=1";
    sqlite3_stmt * statement;
    NSString* result;
    if (sqlite3_prepare_v2(database_, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *License = (char*)sqlite3_column_text(statement, 0);
            result = [[NSString alloc]initWithUTF8String:License];
            
            // NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    return result;
}

-(NSString *)getHardWareString
{
    NSString *sqlQuery = @"SELECT HardWareString FROM AppLicense where idAppLicense=1";
    sqlite3_stmt * statement;
    NSString* result;
    if (sqlite3_prepare_v2(database_, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *HardWareString = (char*)sqlite3_column_text(statement, 0);
            result = [[NSString alloc]initWithUTF8String:HardWareString];
            
            // NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    return result;
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(database_, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        //sqlite3_close(database_);
        NSLog(@"数据库操作数据失败!");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RefreshtxtLicense:(id)sender {
    NSString* ss=[self getLicense];
    
    NSString* result=[self CheckLicense:ss];
    self.lbLicenseStatus.text=result;
    self.lbLicenseString.text=ss;
    self.txtNewLicense.text=ss;
}

- (IBAction)SaveNewLicense:(id)sender {
    NSString* NewLicenseString=self.txtNewLicense.text;
    NSString* Checkresult=[self CheckLicense:NewLicenseString];
    if (![Checkresult isEqual:@"授权无效！"]) {
        NSRange NR=[Checkresult rangeOfString:@"已"];
        int intNR=NR.length;
        if (intNR<=0 ) {
            //可以保存了
            NSMutableString *UpdateSQL=[[NSMutableString alloc] initWithString:@""];
            [UpdateSQL appendString:@"update  AppLicense set LicenseString='"];
            [UpdateSQL appendString:NewLicenseString];
            [UpdateSQL appendString:@"' where idAppLicense=1"];
            [self execSql:UpdateSQL];
            self.lbLicenseString.text=NewLicenseString;
            self.lbLicenseStatus.text=Checkresult;
            self.txtNewLicense.text=@"";
        }
    }
    
 
}

-(NSString*)CheckLicense:(NSString*)LicenseString
{
    NSMutableString *ExpiredDateString = [[NSMutableString alloc] initWithString:@""];
    if (LicenseString !=nil) {
        if (LicenseString.length!=30) {
            return @"授权无效！";
        }
        @try {
            [ExpiredDateString appendString:[self StringDecrypt:LicenseString]];
             //priedDateString=;
            @try {
                if ([ExpiredDateString isEqual:@"9999-12-31"]) {
                    return @"授权类型：永久";
                }
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //设置日期格式
                NSDate *today = [NSDate date]; //当前日期
                
                NSString *date = ExpiredDateString; //开始日期
                NSDate *ExpiredDate;
                @try {
                    ExpiredDate = [dateFormatter dateFromString:date];  //开始日期，将NSString转为NSDate
                }
                @catch (NSException *exception) {
                    return @"授权无效！";
                }

                NSDate *r = [today laterDate:ExpiredDate];  //返回较晚的那个日期
                
                if([today isEqualToDate:ExpiredDate]) {
                    [ExpiredDateString appendString:@",未过期"];
                    return ExpiredDateString;
                    
                }else{
                    
                    if([r isEqualToDate:ExpiredDate]) {
                        [ExpiredDateString appendString:@",未过期"];
                        return ExpiredDateString;
                        
                    }else{
                        
                        NSLog(@"已过期");
                        [ExpiredDateString appendString:@",已过期"];
                        return ExpiredDateString;
                        // [self.myFinishedOrders addObject:ar];
                        
                    }
                    
                }
            }
            @catch (NSException *exception) {
                return @"授权无效！";
            }

        }
        @catch (NSException *exception) {
            return @"授权无效！";
        }

        
        
    }
         return @"授权无效！";
}
-(NSString*)StringDecrypt:(NSString*)LicenseString
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    NSString* RandomSeed=[LicenseString substringWithRange:NSMakeRange(0, 10)];
    NSString* EncryptString=[LicenseString substringWithRange:NSMakeRange(10, 20)];
    for (int i=0; i<10; i++) {
        unichar charA = [RandomSeed characterAtIndex:i];
        int intA=(int)charA;
        NSString* stringC=[EncryptString substringWithRange:NSMakeRange(i*2, 2)];
        int intC=[self HexStringToInteger:stringC];
        int intB=intC-intA;
        char charB=(char)intB;
        [result appendFormat:@"%c",charB];
    }
    return result;
}

-(NSInteger)HexStringToInteger:(NSString *)HexString
{
    int int_ch=0;  /// 两位16进制数转化后的10进制数
    int i=0;
    unichar hex_char1 = [HexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
    int int_ch1;
    if(hex_char1 >= '0' && hex_char1 <='9')
        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
    else if(hex_char1 >= 'A' && hex_char1 <='F')
        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
    else
        int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
    i=i+1;
    
    unichar hex_char2 = [HexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
    int int_ch2;
    if(hex_char2 >= '0' && hex_char2 <='9')
        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
    else if(hex_char2 >= 'A' && hex_char2 <='F')
        int_ch2 = hex_char2-55; //// A 的Ascll - 65
    else
        int_ch2 = hex_char2-87; //// a 的Ascll - 97
    
    int_ch = int_ch1+int_ch2;
    //NSLog(@"int_ch=%d",int_ch);
    return int_ch;
}

@end
