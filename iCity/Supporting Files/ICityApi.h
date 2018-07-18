//
//  ICityApi.h
//  ICity
//
//  Created by 王磊 on 2018/4/19.
//  Copyright © 2017年 ICity. All rights reserved.
//

#ifndef ICityApi_h
#define ICityApi_h

//线上
#define ICity_BASE              @"http://data.aba.com.cn:13000/iCity_interface/"
//本地
//#define ICity_BASE              @"http://10.10.10.126:8080/iCity_interface/"

/***********************************推荐****************************************/

/**广告标签添加*/
#define ICity_LABEL_ADD                     ICity_BASE @"home/homepage/addtag.htm"
/**标签页面是否弹出判断*/
#define ICity_LABEL_SELECTED                ICity_BASE @"home/homepage/ischoicetag.htm"
/**标签页面是否弹出判断*/
#define ICity_WELCOMEPAGE                   ICity_BASE @"headhome/welcomePage.htm"

/**每日一签*/
#define DAILY_SING_IN                       ICity_BASE @"headcustomer/getcustomerinfo.htm"


/**公共的广告banner*/
#define BANNER_LIST_URL                     ICity_BASE @"headhome/banneralllist.htm"

/**精选频道*/
#define CHANNEL_LIST_URL                    ICity_BASE @"headLineCate/catelistsecond.htm"
/**频道排序编辑*/
#define CHANNEL_EDITSORT_URL                ICity_BASE @"headLineCate/editCate.htm"
/**热门搜索*/
#define HOT_SEARCH_URL                      ICity_BASE @"headsearch/hotsearch.htm"
/**历史搜索*/
#define HISTORY_SEARCH_URL                  ICity_BASE @"headsearch/hissearch.htm"
/**清空历史搜索*/
#define CLEAN_HISTORY_SEARCH_URL            ICity_BASE @"headsearch/deletehissearch.htm"
/**搜索结果:综合、文章、视频、直播、图集、iCity号*/
#define SEARCH_RESULT_URL                   ICity_BASE @"headsearch/searchresultsecond.htm"
/**精选首页*/
#define HOME_PAGE_URL                       ICity_BASE @"headhome/headdata.htm"
/**推荐接口*/
#define HOME_TUIIJANPAGE_URL                ICity_BASE @"headhome/headdata/third.htm"
/**推荐置顶接口*/
#define HOME_TUIIJANTOP_URL                 ICity_BASE@"headhome/headdata/top.htm"
/**精选视频*/
#define HOME_PAGE_VIDEO_URL                 ICity_BASE @"videohome/videolist.htm"
/**精选图集、文章*/
#define HOME_PICTURE_ARTICLE_URL            ICity_BASE @"headhome/articlelist.htm"
/**文章详情*/
#define ARTICLE_DETAIL_URL                  ICity_BASE @"headarticle/articledetail.htm"
/**图集详情*/
#define PICTURE_ARTICLE_URL                 ICity_BASE @"headarticle/getHeadArticlePicture.htm"
/**分享文章、视频、直播、活动、自媒体*/
#define COMMON_SHARE_URL                    ICity_BASE @"headDiscovery/shareinfo.htm"
/**关注栏目首页*/
#define JMNUM_HOME_LIST_URL                 ICity_BASE @"headmedia/mediarecolist.htm"

/**每日一签*/
#define ICity_COUPON_DAYQIANDAO_URL         ICity_BASE @"usersignup/shareIndexSignup.htm"

/***********************************阅读****************************************/

/**阅览室*/
#define Read_ReadingRoom_URL             ICity_BASE @"other/readinghomelist.htm"
/**知识库*/
#define Read_Knowledge_URL               ICity_BASE @"other/knowledgelist.htm"
//新的知识库接口
#define Read_Headmedia_URL               ICity_BASE @"headmedia/mediafieldsecond.htm"
//新的知识库二级接口
#define Read_Mediafield_URL              ICity_BASE @"headmedia/mediafieldsecond.htm"
//新知识库三级
#define Read_Mediafieldsecond_URL        ICity_BASE @"headmedia/mediafieldsecond.htm"
/**自媒体右侧分类*/
#define JMNUM_RIGHT_CATE_URL                ICity_BASE @"headmedia/medialist.htm"

/***********************************聚会API****************************************/
//#define JSTYLE_PARTY_HOME_URL            ICity_BASE @"homeicondata/homeparty.htm"
//#define JSTYLE_PARTY_MORE_URL            ICity_BASE @"homeicondata/homepartymore.htm"
/**文章点赞的判断*/
#define JSTYLE_PARTY_DESC_URL            ICity_BASE @"homeicondata/homepartydetail.htm"
#define JSTYLE_PARTY_SIGNIN_URL          ICity_BASE @"homeicondata/partysigninfo.htm"
#define JSTYLE_PARTY_INFOR_URL           ICity_BASE @"homeicondata/partysignup.htm"
#define JSTYLE_PARTY_ADDCOMMENT_URL      ICity_BASE @"homeicondata/partyaddcomment.htm"
#define JSTYLE_PARTY_COMMENT_URL         ICity_BASE @"homeicondata/partycommentlist.htm"
#define JSTYLE_SIGNUP_SUCCESS_URL        ICity_BASE @"homeicondata/partysignsuccess.htm"
#define JSTYLE_PARTY_PAY_INFO_URL        ICity_BASE @"homeicondata/partypaypage.htm"
#define JSTYLE_MY_PARTY_URL              ICity_BASE @"homeicondata/getpartylist.htm"
#define JSTYLE_MY_PARTY_CANCEL_URL       ICity_BASE @"homeicondata/partyCancelSignup.htm"

/***********************************文化****************************************/

/**公告牌*/
#define Culture_Callboard_URL            ICity_BASE @"other/noticelist.htm"
/**热门节目*/
#define Culture_Hot_Program_URL          ICity_BASE @"other/hotvideolist.htm"
/**电视栏目列表*/
#define Culture_TV_Menu_URL              ICity_BASE @"other/tvcatelist.htm"
/**电视列表*/
#define Culture_TV_List_URL              ICity_BASE @"other/tvlist.htm"
/**广播列表*/
#define Culture_Broadcast_List_URL       ICity_BASE @"other/radiolist.htm"
/**报纸列表*/
#define Culture_Newspaper_List_URL       ICity_BASE @"other/newspaperlist.htm"
//新媒体上
#define Culture_NewMediaHead_URL         ICity_BASE @"headmedia/medialist.htm"
//新媒体下边列表
#define Read_NewMedia_URL                ICity_BASE@"headmedia/contentlist.htm"

/**文化活动Tab列表数据*/
#define Culture_Popular_Activities_URL   ICity_BASE @"homeicondata/homeparty.htm"
/**更多文化活动*/
#define Culture_More_Activities_URL      ICity_BASE @"homeicondata/homepartymore.htm"
//更过列表 地区标签
#define Culture_Regionlist_URL           ICity_BASE @"other/regionlist.htm"
//更过列表 时间标签
#define Culture_Timelist_URL             ICity_BASE @"other/timelist.htm"


/***********************************生活****************************************/

/**生活分类菜单*/
#define Life_CateList_URL                ICity_BASE @"other/lifecatelist.htm"


/***********************************视频****************************************/
/**文章、视频、活动添加评论*/
#define ADD_COMMENT_URL                  ICity_BASE @"headDiscovery/addcomment.htm"
/**文章、视频、活动的评论列表*/
#define COMMENT_LIST_URL                 ICity_BASE @"headDiscovery/commentlist.htm"
/**视频详情*/
#define VIDEO_DETAIL_URL                 ICity_BASE @"videohome/videodetail.htm"
/**盖楼评论*/
#define COVER_COMMENT_URL                ICity_BASE @"headDiscovery/soncommentlist.htm"
/**文章、视频获取点赞、收藏状态*/
#define GET_PRAISESTATE_URL              ICity_BASE @"headuseraction/headfollowstate.htm"
/**文章、视频、iCity号添加点赞*/
#define ADD_PRAISE_URL                   ICity_BASE @"headuseraction/headaddpraise.htm"
/**文章、视频、iCity号添加收藏*/
#define ADD_COLLECTION_URL               ICity_BASE @"headuseraction/headaddfollow.htm"


/***********************************发现****************************************/
/**发现首页*/
#define DISCOVERY_PAGE_URL               ICity_BASE @"headDiscovery/discoverylist.htm"
/**投票、测试首页*/
#define DISCOVERY_VOTE_URL               ICity_BASE @"headDiscovery/votedetail.htm"
/**投票结果*/
#define DISCOVERY_VOTE_RESULT_URL        ICity_BASE @"headDiscovery/voteresult.htm"
/**测试结果*/
#define DISCOVERY_TEST_RESULT_URL        ICity_BASE @"headDiscovery/testresult.htm"
/**判断是否参与*/
#define DISCOVERY_TEST_ISJOINED_URL      ICity_BASE @"headDiscovery/isjoindis.htm"


/***********************************iCity号**************************************/
/**注册iCity号是否存在名字*/
#define MANAGER_REPEATED_NAME            ICity_BASE @"usermedia/isRepeatedName.htm"
/**管理iCity号消息*/
#define MANAGER_LIST_URL                 ICity_BASE @"headmedia/usermediacontent.htm"
#define MANAGER_COUNTNUM_URL             ICity_BASE @"usermedia/usermedianums.htm"
/**iCity号-我的消息*/
#define MANAGER_MYMESSAGE_URL            ICity_BASE @"myvideodata/myvideomsg.htm"
/**iCity号-账号信息*/
#define MANAGER_ACCOUNT_INFO_URL         ICity_BASE @"usermedia/usermediainformation.htm"
#define MANAGER_COMMENT_URL              ICity_BASE @"usermedia/usermediacomment.htm"
#define MANAGER_ISREGESTER_URL           ICity_BASE @"usermedia/isusermedia.htm"
#define MANAGER_ADDUSERMEDIA_URL         ICity_BASE @"usermedia/addusermedia.htm"
#define MANAGER_USERMEDIAFORL_URL        ICity_BASE @"usermedia/usermediaforl.htm"
#define MANAGER_USERMEDIAINFORMATION_URL ICity_BASE @"usermedia/usermediainformation.htm"
#define MANAGER_PROTOCOL_URL             ICity_BASE @"usermedia/mediaprotocol.htm"
#define MANAGER_NOTICEDERAIL_URL         ICity_BASE @"myvideodata/noticedetail.htm"
/**iCity号订阅*/
#define MANAGER_SUBSCRIPTION_URL         ICity_BASE @"home/homepage/addmedia.htm"
/**iCity号详情信息*/
#define MANAGER_DETAILINFO_URL           ICity_BASE @"headmedia/mediadetail.htm"
/**iCity号详情列表*/
#define MANAGER_HOMELIST_URL             ICity_BASE @"headmedia/mediacontent.htm"
/**更多iCity号*/
#define MANAGER_MORELIST_URL             ICity_BASE @"home/homepage/medialist.htm"
/**我的关注*/
#define PERSONAL_MY_MEDIA_DY_URL         ICity_BASE @"user/getmymedialist.htm"
/**个人资料*/
#define MY_INFORMATION_URL               ICity_BASE @"user/userinfolist.htm"
/**上传头像*/
#define MY_POSTICON_URL                  ICity_BASE @"user/updateavator.htm"
/**修改昵称*/
#define MY_CHANGENICK_URL                ICity_BASE @"user/updatenickname.htm"
/**修改性别*/
#define MY_CHANGEGENDER_URL              ICity_BASE @"user/updategender.htm"
/**修改生日*/
#define MY_CHANGEBIRTH_URL               ICity_BASE @"user/updatebirth.htm"
/**帮助中心反馈留言*/
#define MY_HELPCENTER_BACKMESSAGE_URL    ICity_BASE @"user/feedback.htm"
/**个人资料页面修改密码*/
#define CHANGE_PWD_URL                   ICity_BASE @"user/updatepassword.htm"
/**个人资料页面设置密码*/
#define JSYTLE_SET_PWD_URL               ICity_BASE @"headuser/setpassword.htm"
/**获取验证码*/
#define GET_CODE_URL                     ICity_BASE @"headuserlogin/sendmsgsecond.htm"
/**意见反馈*/
#define POST_FEEDBACK                    ICity_BASE @"user/feedback.htm"
/**最近阅读*/
#define RECENT_READ_URL                  ICity_BASE @"headuser/browselist.htm"

/***********************************我的模块************************************/
/**登陆后的我的信息*/
#define LOGIN_USERINFO_URL               ICity_BASE @"headuser/userinfo.htm"
/**我的收藏*/
#define USERINFO_FOLLOWLIST_URL          ICity_BASE @"headuser/followslist.htm"
/**我的评论*/
#define USERINFO_COMMENTLIST_URL         ICity_BASE @"headuser/commentlist.htm"
/**我的消息*/
#define USERINFO_MSGLIST_URL             ICity_BASE @"headuser/msglist.htm"
/**分享APP*/
#define SAHRE_MYAPP_URL                  ICity_BASE @"home/homepage/shareApp.htm"

/***********************************登录注册************************************/
/**手机、密码登录*/
#define MOBILE_LOGIN_URL                 ICity_BASE @"headuserlogin/headphonelogin.htm"
/**第三方登录*/
#define THIRD_LOGIN_URL                  ICity_BASE @"headuserloginsecond/isbind.htm"
/**绑定手机号*/
#define BIND_MOBILE_URL                  ICity_BASE @"headuserloginsecond/bindphone.htm"
/**验证码登录*/
#define LOGIN_CODE_URL                   ICity_BASE @"headuserlogin/headvalidcodelogin.htm"
/**忘记密码*/
#define FIND_PWD_URL                     ICity_BASE @"user/forgetpwd.htm"
/**改绑手机号*/
#define MOBILE_CHANGE_BIND_URL           ICity_BASE @"headuserloginsecond/changebindphone.htm"
/**第三方绑定情况*/
#define THIRD_BIND_STATE_URL             ICity_BASE @"headuserloginsecond/bindstate.htm"
/**第三方绑定操作*/
#define THIRD_PART_BIND_URL              ICity_BASE @"headuserloginsecond/bindthird.htm"
/**第三方解除绑定操作*/
#define THIRD_REMOVE_BIND_URL            ICity_BASE @"headuserloginsecond/relievebind.htm"

/***********************************会员****************************************/
/**收益总榜*/
#define VIP_EARNING_LIST_URL             ICity_BASE @"homeminevip/profitlist.htm"
/**我邀请的会员*/
#define VIP_INVITE_MEMBERS_URL           ICity_BASE @"homeminevip/myinvitelist.htm"
/**账单明细*/
#define VIP_BILL_LIST_URL                ICity_BASE @"homeminevip/billlist.htm"
/**是否绑定手机, 身份证号*/
#define VIP_IS_BINDED_URL                ICity_BASE @"homeminevip/bindresult.htm"
/**VIP绑定手机号*/
#define VIP_BIND_MOBILE_URL              ICity_BASE @"homeminevip/bindphone.htm"
/**VIP绑定身份证*/
#define VIP_BIND_NAMEID_URL              ICity_BASE @"homeminevip/bindinfo.htm"
/**VIP申请提现*/
#define VIP_GET_CASH_URL                 ICity_BASE @"homeminevip/getcash.htm"
/**VIP内购*/
#define VIP_PAY_URL                      ICity_BASE @"apppay/iosvipdown.htm"

/***********************************积分抽奖****************************************/

/**积分商城商品列表*/
#define MY_JIFEN_MALL_URL                ICity_BASE @"user/getmyintegralmall.htm"
/**积分商城签到*/
#define MY_JIFEN_QIANDAO_URL             ICity_BASE @"usersignup/signuppage.htm"
/**我的积分*/
#define MY_JIFEN_URL                     ICity_BASE @"user/userIngegralDetail.htm"
/**签到抽奖分享*/
#define QIANDAO_LUCKYDRAW_URL            ICity_BASE @"usersignup/shareIndexSignup.htm"

#endif /* ICityApi_h */
