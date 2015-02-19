//
//  mainScreen.m
//  UDCSiOSApp4
//
//  Created by WL on 13-10-4.
//  Copyright (c) 2013年 WL. All rights reserved.
//

#import "mainScreen.h"
#import "subScreen.h"
#import "ComputeToken.h"


@interface mainScreen ()
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *lbToken;
@property (weak, nonatomic) IBOutlet UILabel *lbMainTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCompany;
@property (weak, nonatomic) IBOutlet UIButton *btnGetToken;
@property (weak, nonatomic) IBOutlet UIButton *btnGotoSettings;
- (IBAction)GotoSettings:(id)sender;
- (IBAction)GetTokenString:(id)sender;
@end

@implementation mainScreen


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
    //开始第一个线程。
    NSThread *ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(ChangeTimeMethod) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
    
    //初始化数据库
    [self initDBAddress];
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *MajorVersion=[systemVersion substringToIndex:1];
    //self.lbToken.text=[NSString stringWithFormat:@"%@",MajorVersion];
    if ([MajorVersion isEqualToString:@"6"]) {
       //self.lbCurrentTime.autoresizingMask=
        //CGRect rect=[self.lbCurrentTime [[UILabel alloc] initWithFrame:CGRectMake(135, 290,200,35)];
        [self.lbCurrentTime setFrame:CGRectMake(0, 24,320,21)];
        [self.lbMainTitle setFrame:CGRectMake(0, 53,320,68)];
        [self.lbCompany setFrame:CGRectMake(171, 109,120,21)];
        [self.lbToken setFrame:CGRectMake(0, 201,320,56)];
        [self.btnGetToken setFrame:CGRectMake(43, 273,234,51)];
        [self.btnGotoSettings setFrame:CGRectMake(43, 331,234,44)];

    }
}
- (void)ChangeTimeMethod
{
    while (TRUE) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
        [self performSelectorOnMainThread:@selector(updateTime:) withObject:currentDateStr waitUntilDone:YES];
        [NSThread sleepForTimeInterval:1];
    }
}

- (void)updateTime:(NSString *)txt
{
    //更新显示时间
    self.lbCurrentTime.text=txt;
    //整分钟置空
    NSString *strSecond=[txt substringFromIndex:17];
    if ([strSecond isEqual:@"00"]) {
        self.lbToken.text=@"---";
    }
}

//初始化数据库
-(void)initDBAddress
{
    [self openDataBase];
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
    if(sqlite3_open([path UTF8String], &database_) == SQLITE_OK) {
        //FirstCreate_ = YES;
        [self createChannelsTable:database_];//在后面实现函数createChannelsTable
        [self insertOneChannel];
        //        NSString *sqlInsertTable = @"INSERT INTO AppLicense (idAppLicense, LicenseString) VALUES (1,'701TG8SP64E77762EA47D11EE0B168D6BD74425E')";
        //        [self execSql:sqlInsertTable];
        
        return YES;
    } else {
        sqlite3_close(database_);
        NSLog(@"Error: open database file.");
        return NO;
    }
    return NO;
}

- (BOOL) createChannelsTable:(sqlite3*)db{
    char *sql = "CREATE TABLE IF NOT EXISTS AppLicense (idAppLicense INT PRIMARY KEY, LicenseString VARCHAR(45),HardWareString VARCHAR(45))";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create channels table");
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:CREATE TABLE channels");
        return NO;
    }
    NSLog(@"Create table 'channels' successed.");
    return YES;
}

- (BOOL) insertOneChannel{
    sqlite3_stmt *statement;
    //int value = (arc4random() % 10);
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@""];
    for (int i=0; i<6; i++) {
        int value = (arc4random() % 10);
        NSString* str1=[[NSString alloc] initWithFormat:@"%d",value];
        [str appendString:str1];
    }
    NSString* strinsert=[[NSString alloc] initWithFormat:@"INSERT INTO AppLicense (idAppLicense, LicenseString,HardWareString) VALUES (1,'8M4VKT6N5171866D8F7885687B6862','%@')",str];
    char *sql = [strinsert UTF8String];;
    
    //问号的个数要和(cid,title,imageData,imageLen)里面字段的个数匹配，代表未知的值，将在下面将值和字段关联。
    int success = sqlite3_prepare_v2(database_, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert:channels");
        return NO;
    }
    
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database with message.");
        return NO;
    }
    
    //NSLog(@"Insert One Channel#############:id = %@",channel.id_);
    return YES;
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(database_, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        //sqlite3_close(database_);
        NSLog(@"数据库操作数据失败!");
    }
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GotoSettings:(id)sender {
    subScreen *secondView = [[subScreen alloc] init];
    [self.navigationController pushViewController:secondView animated:YES];
    secondView.title = @"设置";
    
}

- (IBAction)GetTokenString:(id)sender {
    ComputeToken *CT=[[ComputeToken alloc] init];
    CT.IMEI=[self getHardWareString];
    //CT.IMEI=@"336488";
    //CT.LicenseString=@"701TG8SP64E77762EA47D11EE0B168D6BD74425E";
    
    CT.LicenseString=[self getLicense];
    
    NSString* NewLicenseString=CT.LicenseString;
    if ([NewLicenseString isEqualToString:@""]) {
        self.lbToken.text=@"请注册";
    }
    else
    {
        NSString* Checkresult=[self CheckLicense:NewLicenseString];
        if (![Checkresult isEqual:@"授权无效！"]) {
            NSRange NR=[Checkresult rangeOfString:@"已"];
            int intNR=NR.length;
            if (intNR<=0 ) {
                //可以计算了
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式,这里可以设置成自己需要的格式
                NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
                CT.ConditionDateTime=currentDateStr;//@"2013-09-26 19:47"
                //CT.ConditionDateTime=@"2013-09-26 19:47";
                //self.lb.text=CT.IMEI;
                NSString *TokenString= CT.GetToken;
                self.lbToken.text=TokenString;
            }
            else
            {
                self.lbToken.text=@"授权已过期";
            }
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
