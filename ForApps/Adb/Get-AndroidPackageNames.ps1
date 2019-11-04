
# 阿里
$aliAppMap = @{
  'alipay'            = 'com.eg.android.AlipayGphone' # 支付宝
  'taobao'            = 'com.taobao.taobao';         # 淘宝
  'tmall'             = 'com.tmall.wireless'         # 天猫
  'etao'              = 'com.taobao.etao';           # 一淘
  'cainiao'           = 'com.cainiao.wireless';      # 菜鸟裹裹
  'idleFish'          = 'com.taobao.idlefish';       # 闲鱼
  'aliTrip'           = 'com.taobao.trip';           # 飞猪（原阿里旅行）
  'koubei'            = 'com.taobao.mobile.dipei';   # 口碑
  'uc'                = 'com.UCMobile';              # UC浏览器
  'youku'             = 'com.youku.phone';           # 优酷
  'xiami'             = 'fm.xiami.main';             # 虾米音乐
  'autoNaviMap'       = 'com.autonavi.minimap';      # 高德地图
}

# 腾讯
$tencentAppMap = @{
  'micromsg'          = 'com.tencent.mm';                 # 微信
  'tencentNews'       = 'com.tencent.news';               # 腾讯新闻
  'tencentNewsLite'   = 'com.tencent.news.lite';          # 腾讯新闻极速版
  'pacewear'          = 'com.tencent.tws.gdevicemanager'; # 真时运动
}

# 百度
$baiduAppMap = @{
  'baidu'             = 'com.baidu.searchbox';          # 百度
  'baiduNetDisk'      = 'com.baidu.netdisk';            # 百度网盘
  'baiduNetDiskSns'   = 'com.baidu.netdisk.sns';        # 百度网盘SNS（百度网盘组件）
  'aiqiyi'            = 'com.qiyi.video';               # 爱奇艺
  'aiqiyiLite'        = 'tv.pps.mobile';                # 爱奇艺极速版
  'baiduTieba'        = 'com.baidu.tieba';              # 百度贴吧
  'baiduMap'          = 'com.baidu.BaiduMap';           # 百度地图
}

# 字节跳动
$byteDanceAppMap = @{
  'toutiao'           = 'com.ss.android.article.news'; # 今日头条
  'toutiaoLite'       = 'com.ss.android.article.lite'; # 今日头条极速版
  'tiktok'            = 'com.ss.android.ugc.aweme';    # 抖音
  'duoshan'           = 'my.maya.android';             # 多闪
}

# 京东
$jdAppMap = @{
  'jdMall'            = 'com.jingdong.app.mall';     # 京东商城
  'jdJr'              = 'com.jd.jrapp';              # 京东金融
  'jdReader'          = 'com.jd.app.reader';         # 京东阅读
  'jdStock'           = 'com.jd.stock';              # 京东股票
}

# 其它
$otherAppMap = @{
  'sinaWeibo'         = 'com.sina.weibo';                  # 新浪微博
  'sinaWeiboLite'     = 'com.sina.weibolite';              # 新浪微博极速版
  'aida64'            = 'com.finalwire.aida64';            # AIDA64 Android
  'mxPlayer'          = 'com.mxtech.videoplayer';          # MX Player
  'jetAudioPlus'      = 'com.jetappfactory.jetaudioplus';  # jetAudio Plus
  'perfectViewer'     = 'com.rookiestudio.perfectviewer';  # Perfect Viewer
  'dmzj'              = 'com.dmzj.manhua';                 # 动漫之家
  'misfit'            = 'com.misfitwearables.prometheus';  # misfit
  'xiaomiHealth'      = 'com.xiaomi.hm.health'             # 小米运动
  'smzdm'             = 'com.smzdm.client.android';        # 什么值得买
  'taofen8'           = 'com.leixun.taofen8';              # 淘粉吧
  'manmanbuy'         = 'com.manmanbuy.bijia';             # 慢慢买
  'moximoxi'          = 'com.moxi.MoXiB2C';                # 摩西摩西
  'unionPay'          = 'com.unionpay';                    # 银联云闪付
}

# return the combined map
$combinedMap = $aliAppMap + $tencentAppMap + $baiduAppMap + $byteDanceAppMap + $jdAppMap + $otherAppMap
return $combinedMap



# create a new map by adding prefix for each value in the map 
function New-MapWithPrefix($map, $prefix) {
  $returnMap = @{} 
  foreach ($name in $map.Keys) {
    $returnMap[$name] = $prefix + $map[$name]
  }
  $returnMap
}
