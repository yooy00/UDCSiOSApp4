//
//  ComputeToken.m
//  HelloWold_OBC
//
//  Created by WL on 13-10-2.
//  Copyright (c) 2013年 WL. All rights reserved.
//

#import "ComputeToken.h"
#import <CommonCrypto/CommonDigest.h>
#import <math.h>

@implementation ComputeToken

//初始化三个变量
@synthesize ConditionDateTime=_ConditionDateTime;
@synthesize IMEI=imei;
@synthesize LicenseString=licensestring;
- (id) initConditionDateTime:(NSString *)ConditionDateTime
{
    self=[super init];
    _ConditionDateTime=[ConditionDateTime copy];
    return self;
}
- (id) initIMEI:(NSString *)IMEI;
{
    self=[super init];
    imei=[IMEI copy];
    return self;
}
- (id) initLicenseString:(NSString *)LicenseString;
{
    self=[super init];
    licensestring=[LicenseString copy];
    return self;
}
//初始化变量结束

- (id)init
{
    self = [super init];
    if (self) {
        //NSDate *now=[NSDate date];
        _ConditionDateTime=@" ";
        imei=@" ";
        licensestring=@" ";
    }
    return self;
}

//获取Token
- (NSString*) GetToken
{
    //354273052440505
    //MGFNCBED45D1FC1C30A0B66BE5D736536274BAD4
    //2013-09-26 19:47
    if ([imei isEqualToString:@""])
    {
        return @"IMEI Error";
    }
    if ([licensestring isEqualToString:@""])
    {
        return @"License Error";
    }
    if ([_ConditionDateTime isEqualToString:@""])
    {
        return @"DateTime Error";
    }

    NSString *DESKEY = imei;// "354273052440505";
    NSString *StringA = licensestring; //"MGFNCBED45D1FC1C30A0B66BE5D736536274BAD4";
    NSString *RandomSeed = _ConditionDateTime;// "2013-09-26 19:49";
    
    NSData *RequestAuthenticatorData = [RandomSeed dataUsingEncoding: NSUTF8StringEncoding];
    
    NSData *ttData=[[NSData alloc] init];
    ttData=[self ComputeHashString:RequestAuthenticatorData FinalPassword:StringA DESKEY:DESKEY];
    NSMutableString*   sss1 = [[NSMutableString alloc] initWithString:@""];
    NSMutableString*   sss2 = [[NSMutableString alloc] initWithString:@""];

    Byte *ttDataBytes=(Byte *)[ttData bytes];
    for (int i=0; i<ttData.length; i++) {
        NSInteger c = ttDataBytes[i];
        NSString *ThreeNumberString=[self GetThreeNumberString:c];
        if (i%2==0) {
            sss1=[sss1 stringByAppendingString:ThreeNumberString];
            sss1=[sss1 stringByAppendingString:@","];
        }
        else
        {
            sss2=[sss2 stringByAppendingString:ThreeNumberString];
            sss2=[sss2 stringByAppendingString:@","];
        }
    }
    //NSString *safds=sss1;
    NSArray *Part1 = [sss1 componentsSeparatedByString:@","];
    NSArray *Part2 = [sss2 componentsSeparatedByString:@","];
    int count1=[Part1 count];
    int count2=[Part2 count];
    
    NSMutableString *FirstPart =  [[NSMutableString alloc] initWithString:@"000"];
    NSMutableString *SecondPart =  [[NSMutableString alloc] initWithString:@"000"];

    for (int i=0; i<count1; i++) {
        if (![Part1[i] isEqual:@""]) {
            NSString  *a1,*a2, *a3, *b1, *b2, *b3;
            NSInteger c1, c2, c3;
            a1=[FirstPart substringWithRange:NSMakeRange(0, 1)];
            a2=[FirstPart substringWithRange:NSMakeRange(1, 1)];
            a3=[FirstPart substringWithRange:NSMakeRange(2, 1)];
            
            b1=[Part1[i] substringWithRange:NSMakeRange(0, 1)];
            b2=[Part1[i] substringWithRange:NSMakeRange(1, 1)];
            b3=[Part1[i] substringWithRange:NSMakeRange(2, 1)];
            
            c1=  [a1 intValue]+[b3 integerValue];
            c2=  [a2 intValue]+[b2 integerValue];
            c3=  [a3 intValue]+[b1 integerValue];
            
            c1=c1%10;
            c2=c2%10;
            c3=c3%10;

            FirstPart=[NSMutableString stringWithFormat:@"%d%d%d",c1,c2,c3];
        }
    }
    
    for (int i=0; i<count2; i++) {
        if (![Part2[i] isEqual:@""]) {
            NSString  *a1,*a2, *a3, *b1, *b2, *b3;
            NSInteger c1, c2, c3;
            a1=[SecondPart substringWithRange:NSMakeRange(0, 1)];
            a2=[SecondPart substringWithRange:NSMakeRange(1, 1)];
            a3=[SecondPart substringWithRange:NSMakeRange(2, 1)];
            
            b1=[Part2[i] substringWithRange:NSMakeRange(0, 1)];
            b2=[Part2[i] substringWithRange:NSMakeRange(1, 1)];
            b3=[Part2[i] substringWithRange:NSMakeRange(2, 1)];
            
            c1=  [a1 intValue]+[b3 integerValue];
            c2=  [a2 intValue]+[b2 integerValue];
            c3=  [a3 intValue]+[b1 integerValue];
            
            c1=c1%10;
            c2=c2%10;
            c3=c3%10;
            
            SecondPart=[NSMutableString stringWithFormat:@"%d%d%d",c1,c2,c3];
        }
    }

    return [FirstPart stringByAppendingString:SecondPart];
}


- (NSData*) ComputeHashString:(NSData *)RequestAuthenticatorData FinalPassword:(NSString*)FinalPasswordString DESKEY:(NSString*)DESKEYString
{
    NSString *SecretString=DESKEYString;
    NSMutableData *keyData=[[NSMutableData alloc]init];//开始组织计算PasswordAuthenticator用的byte[]
    [keyData appendData:[[NSString stringWithFormat:@"%@",SecretString] dataUsingEncoding:NSUTF8StringEncoding]];
    for (int i=0;i<16;i++)
    {
        Byte *bt = (Byte *)[RequestAuthenticatorData bytes];
        //NSData* bt=RequestAuthenticatorData.bytes[i];
        Byte byte[] = {bt[i]};
        //NSString *str = [NSString stringWithFormat:@"%", i];
        NSMutableData *testData = [[NSMutableData alloc] initWithBytes:byte length:1];
        NSString *aString = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
        [keyData appendData:[[NSString stringWithFormat:@"%@",aString] dataUsingEncoding:NSUTF8StringEncoding]];
    }//结束组织计算用的byte[]
    
    NSString *keyString = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    NSString *hash=[self md5:keyString];
    NSString *hashed= [hash stringByReplacingOccurrencesOfString :@"-" withString:@""];
    NSInteger rounds=(NSInteger)ceil((double)FinalPasswordString.length/16);
    //**************************
    NSMutableData *resultData=[[NSMutableData alloc]init];
    //var result = new byte[rounds * 16];
    for (int j=0; j<rounds; j++) {
        NSString *currentChunkStr;
        if (FinalPasswordString.length<(j+1)*16) {
            NSRange rang = NSMakeRange(j * 16, FinalPasswordString.length - j * 16);
            currentChunkStr = [FinalPasswordString substringWithRange:rang];
        }
        else
        {
            NSRange rang = NSMakeRange(j * 16, 16);
            currentChunkStr = [FinalPasswordString substringWithRange:rang];
        }
        for (int i = 0; i <= 15; i++)
        {
            NSInteger pp;
            NSInteger pm;
            NSInteger pc;
            if (2*i>hashed.length) {
                pm=0;
            }
            else
            {
                NSRange rang = NSMakeRange(2 * i,2);
                NSString *hashedSubstring;
                @try {
                    hashedSubstring = [hashed substringWithRange:rang];
                }
                @catch (NSException *exception) {
                    NSString*a=exception.reason;
                    NSString*b=exception.reason;
                }

                
                pm=[self HexStringToInteger:hashedSubstring];
            }
            if (i>=currentChunkStr.length) {
                pp=0;
            }
            else
            {
                unichar hex_char2 = [currentChunkStr characterAtIndex:i];
                pp=hex_char2;
                
            }
            pc=pm^pp;
            unichar c = pc;
            Byte bytes[1]={c};
            //bytes[0]=c;
            NSData * ac=[[NSData alloc] initWithBytes:bytes length:1];
            [resultData appendData:ac];
        }
        
        //NSData * currentChunkData=[[NSData alloc] initWithBytes:{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} length:16];
        Byte array[] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        NSData *currentChunkData = [NSData dataWithBytes:array  length: 16];
        Byte *bytes1 = (Byte *)[currentChunkData bytes];
        Byte *bytes2 = (Byte *)[resultData bytes];
        for (int copyi=0; copyi<16; copyi++) {
            bytes1[copyi]=bytes2[j*16+copyi];
        }
         NSMutableString *currentKey1 = [[NSMutableString alloc] initWithString:@""];
        currentChunkData=[[NSData alloc] initWithBytes:bytes1 length:16];
        for (int bytes1i=0; bytes1i<16; bytes1i++) {
            unichar cc=bytes1[bytes1i];
            NSString *currentKey0=[self ToHex:cc];
            [currentKey1 appendString:currentKey0];
            //currentKey1= [currentKey1 stringByAppendingString:currentKey0];
        }
        
        NSString *currentKey;
        @try {
            currentKey= [SecretString stringByAppendingString:currentKey1];
        }
        @catch (NSException *exception) {
//            NSString*a=exception.reason;
//            NSString*b=exception.reason;
        }


        hash =[self md5:currentKey];
        hashed= [hash stringByReplacingOccurrencesOfString :@"-" withString:@""];
        
    }
        //***********************
        return resultData;
        
    }
    

-(NSString *) md5:( NSString * )str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString
            stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}
-(NSData*) hexToBytes:(NSString*)HexString{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= HexString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [HexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }
    if (str.length==1) {
        str=[@"0" stringByAppendingString:str];
    }
    return str;  
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

-(NSString *)GetThreeNumberString:(NSInteger)intNumber
{
    NSString *intNumbertoString=[NSString stringWithFormat:(@"%d"), intNumber];
    NSString *Result;
    if (intNumbertoString.length==1) {
        Result=[@"00" stringByAppendingString:intNumbertoString];
    }
    else if (intNumbertoString.length==2)
    {
        Result=[@"0" stringByAppendingString:intNumbertoString];
    }
    else  if (intNumbertoString.length==3)
    {
        Result=[@"" stringByAppendingString:intNumbertoString];
    }
    return Result;
}

@end
