# EMHTTPClient
### EMHTTPClient是一个便利的http请求器
    使用方便，让开发者专注于参数配置和结果解析，无需考虑过程

    涵盖：get post download json解析

## 接口
### 普通接口
```
/**
 *  重置HTTP 头
 *
 */
- (void)resetSerializer;

#pragma mark - ---- HTTP 头

/**
 *  设置自定义HTTP 头
 *
 *  @param value value
 *  @param key   key
 */
- (void)setValue:(id)value forHTTPHeaderKey:(NSString *)key;

#pragma mark - ---- RawData网络请求

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation* )asyncRawDataGet:(NSString *)url
                                  paramters:(NSDictionary *)kvParams
                                    timeout:(NSUInteger)timeout
                                    success:(AFSuccessBlock)successBlock
                                      faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation* )asyncDownloadGet:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，直接返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
- (AFHTTPRequestOperation* )syncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout;


/**
 *  发送Post请求, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;


/**
 *  发送POST请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation* )asyncDownloadPost:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;


/**
 *  发送Post请求, 服务端直接返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
- (AFHTTPRequestOperation *)syncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout;

/**
 *  发送自定义Request, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout
                                        success:(AFSuccessBlock)successBlock
                                          faild:(AFFaildBlock)faildBlock;

/**
 *  发送自定义Request, 服务端直接返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)syncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout;


/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation*)asyncRawDataMultipartFormPost:(NSString *)url
                                               paramters:(NSDictionary *)paramDict
                                             mediaObject:(EMMediaObject *)mediaObj
                                                 timeout:(NSUInteger)timeout
                                                 success:(AFSuccessBlock)successBlock
                                                   faild:(AFFaildBlock)faildBlock;

/**
 *  获取文件信息
 *
 *  @param URLString    url
 *  @param parameters   参数key，value形式
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 *
 *  @return
 */

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         timeout:(NSUInteger)timeout
                         success:(AFSuccessBlock)successBlock
                           faild:(AFFaildBlock)faildBlock;


#pragma mark - ---- 取消正在发送的网络请求

/**
 *  取消请求
 *
 *  @param url          请求的URL，不能为空
 */
- (void)cancelRequest:(NSString*)url;

/**
 *  取消请求
 *
 *  @param operation    请求的operation，不能为空
 */
- (void)cancelOperation:(AFHTTPRequestOperation*)operation;


/**
 *  取消所有请求
 *
 */
- (void)cancelAllRequest;

```
### 类接口
``` Objective-C

/**
 *  重置HTTP 头
 *
 */
+ (void)resetSerializer;

#pragma mark - ---- HTTP 头

/**
 *  设置自定义HTTP 头
 *
 *  @param value value
 *  @param key   key
 */
+ (void)setValue:(id)value forHTTPHeaderKey:(NSString *)key;

/**
 *  设置编码格式 头
 *
 *  @param encodeing 格式
 */
+ (void)setStringEncoding:(NSStringEncoding)encodeing;


#pragma mark - ---- RawData网络请求

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation* )asyncRawDataGet:(NSString *)url
                                  paramters:(NSDictionary *)kvParams
                                    timeout:(NSUInteger)timeout
                                    success:(AFSuccessBlock)successBlock
                                      faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation* )asyncDownloadGet:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，直接返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
+ (AFHTTPRequestOperation* )syncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout;


/**
 *  发送Post请求, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;

/**
 *  发送POST请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation* )asyncDownloadPost:(NSString *)url
                                    paramters:(NSDictionary *)kvParams
                              destinationPath:(NSString *)destinationPath
                                      timeout:(NSUInteger)timeout
                                      success:(AFSuccessBlock)successBlock
                                        faild:(AFFaildBlock)faildBlock;

/**
 *  发送Post请求, 服务端直接返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
+ (AFHTTPRequestOperation *)syncRawDataPost:(NSString *)url
                                  paramters:(NSDictionary *)paramDict
                                    timeout:(NSUInteger)timeout;

/**
 *  发送自定义Request, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout
                                        success:(AFSuccessBlock)successBlock
                                          faild:(AFFaildBlock)faildBlock;

/**
 *  发送自定义Request, 服务端直接返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)syncRawDataRequest:(NSURLRequest *)request
                                       timeout:(NSUInteger)timeout;


/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation*)asyncRawDataMultipartFormPost:(NSString *)url
                                               paramters:(NSDictionary *)paramDict
                                             mediaObject:(EMMediaObject *)mediaObj
                                                 timeout:(NSUInteger)timeout
                                                 success:(AFSuccessBlock)successBlock
                                                   faild:(AFFaildBlock)faildBlock;


/**
 *  获取文件信息
 *
 *  @param URLString    url
 *  @param parameters   参数key，value形式
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 *
 *  @return
 */

+ (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         timeout:(NSUInteger)timeout
                         success:(AFSuccessBlock)successBlock
                           faild:(AFFaildBlock)faildBlock;


#pragma mark - ---- 取消正在发送的网络请求

/**
 *  取消请求
 *
 *  @param url          请求的URL，不能为空
 */
+ (void)cancelRequest:(NSString*)url;

/**
 *  取消请求
 *
 *  @param operation    请求的operation，不能为空
 */
+ (void)cancelOperation:(AFHTTPRequestOperation*)operation;


/**
 *  取消所有请求
 *
 */
+ (void)cancelAllRequest;

```

### 增加json解析 类扩展
``` Objective-C
/**
 *  发送GET请求，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONGet:(NSString *)url
                               paramters:(NSDictionary *)kvParams
                                 timeout:(NSUInteger)timeout
                                 success:(AFSuccessBlock)successBlock
                                   faild:(AFFaildBlock)faildBlock;


/**
 *  发送Post请求, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONPost:(NSString *)url
                                paramters:(NSDictionary *)paramDict
                                  timeout:(NSUInteger)timeout
                                  success:(AFSuccessBlock)successBlock
                                    faild:(AFFaildBlock)faildBlock;


/**
 *  发送自定义Request, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONRequest:(NSURLRequest *)request
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;



/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONMultipartFormPost:(NSString *)url
                                             paramters:(NSDictionary *)paramDict
                                           mediaObject:(EMMediaObject *)mediaObj
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONGet:(NSString *)url
                               paramters:(NSDictionary *)kvParams
                                 timeout:(NSUInteger)timeout
                                 success:(AFSuccessBlock)successBlock
                                   faild:(AFFaildBlock)faildBlock;


/**
 *  发送Post请求, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONPost:(NSString *)url
                                paramters:(NSDictionary *)paramDict
                                  timeout:(NSUInteger)timeout
                                  success:(AFSuccessBlock)successBlock
                                    faild:(AFFaildBlock)faildBlock;


/**
 *  发送自定义Request, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONRequest:(NSURLRequest *)request
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;



/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONMultipartFormPost:(NSString *)url
                                             paramters:(NSDictionary *)paramDict
                                           mediaObject:(EMMediaObject *)mediaObj
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock;
```


## 使用

```Objective-C
[EMHTTPClient asyncRawDataGet:@"http://www.baidu.com"
                        paramters:nil
                          timeout:10
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                              //下载来下
                              
                              [self.webView loadHTMLString:string baseURL:nil];
                              //更新webView
                          } faild:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                          }];
```
![](https://raw.githubusercontent.com/gjzw/EMHTTPClient/master/resource/img1.gif)
