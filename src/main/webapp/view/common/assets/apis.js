//后台的接口地址
var API_PROXY = '';
//后台的接口列表
var APIS = {	    
		
		/**
	     * 匿名登录
	     */
		
	    loginAn: {
	        url: '/loginAn'
	    },
	    login: {
	        url: '/login'
	    },
		
		frmCustomerList: {	        
	    	queryCustomer: {	        
	            url: '/api/query',
	            needLogin: true,
	            tokenKey: 'OnClick_pToolbar_btnCreate_frmCustomerList_jsquery'
	    	},
	    },
	    
	    /**
	     * 缺陷列表
	     */
	    frmIssueList: {	        
	    	queryDefect: {	        
	            url: '/api/query',
	            needLogin: true,
	            tokenKey: 'OnClick_pToolbar_btnQuery_frmIssueList_jsquery'
	    	},
	    	queryDefects: {	        
	            url: '/api/query',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_edit_frmIssueList_jsquery'
	    	},
	    	startWork: {	        
	            url: '/api/savecustom',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_start_frmIssueList_js2'
	    	},
	    	cancelWork: {	        
	            url: '/api/savecustom',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_cancel_frmIssueList_js2'
	    	},
	    	startTest: {	        
	            url: '/api/savecustom',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_test_frmIssueList_js2'
	    	},
	    	closeWork: {	        
	            url: '/api/savecustom',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_close_frmIssueList_js2'
	    	},
	    	reopen: {	        
	            url: '/api/savecustom',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_reopen_frmIssueList_js2'
	    	},
	    	resolve: {	        
	            url: '/api/savecustom',
	            needLogin: true,
	            tokenKey: 'OnClick_pTable_resolve_frmIssueList_js2'
	    	},
	    },
	    
	    /*
		 * 我的
		 */
		frmUserList: {
			queryUser: {         
		         url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnClick_pToolbar_btnQuery_frmUserList_jsquery'
			},
		},
		/*
		 * 新增缺陷
		 */
		frmIssueBugAdd: {
			saveIssueBug: {         
		         url: '/api/save',
		         needLogin: true,
		         tokenKey: 'OnClick_pnlUp_ctlConfirm_frmIssueBugAdd_jssave'
			},
		},

		/*
		 * 新增缺陷的附件上传
		 */		
		issueFileAdd:{
			saveissueFile:{
				 url: '/api/save',
		         needLogin: true,
		         tokenKey: 'OnClick_pnlDown_ctlSave_issueFileAdd_jssave'
			},
		},
		
		/*
		 * 附件显示
		 */
		frmIssueView:{
			query:{
		    	url: '/api/query',
		    	needLogin: true,
		        tokenKey: 'OnLoad__frmIssueView_queryFile'
		   },
		},
		/*
		 * 修改密码
		 */		
		frmUserEdit:{
			updatepassword:{
				 url: '/api/save',
		         needLogin: true,
		         tokenKey: 'OnClick_pToolbar_btnSave_frmUserEdit_jssave'
			},
		},
		
		/*
		 * 公告管理
		 */
		frmAnnouncementList:{
			query:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnLoad__frmAnnouncementList_Query'
			},
		},
		/*
		 * 项目动态
		 */
		issueLogList:{
			query:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnLoad__issueLogList_jsQuery'
			},
		},
		/*
		 * 个人工作台
		 */
		frmMyDashboard:{
			query1:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnLoad__frmMyDashboard_j1'
			},
			query2:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnLoad__frmMyDashboard_j2'
			},
		},
		/**
		 * 联系我们
		 */
		frmSaleBusinessAdd:{
			save:{
				 url: '/api/save',
		         needLogin: false,
		         tokenKey: 'OnClick_saleClueDown_ctlSave_frmSaleBusinessAdd_jsave'
			},
		},
		frmBusinessList:{
			query:{
				 url: '/api/query',
		         needLogin: false,
		         tokenKey: 'OnClick_pToolbar_btnQuery1_frmBusinessList_Query'
			},
		},
		/**
		 * 权限查找
		 */
		frmUserView:{
			query:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnLoad__frmUserView_q2'
			},
		},
		
		/**
		 * 资源标识
		 */
		sysResList:{
			query:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnClick_pnlTree_sysResList_query'
			},
		},
		frmResDownList:{
			query:{
				 url: '/api/query',
		         needLogin: true,
		         tokenKey: 'OnClick_pToolbar_btnQuery_frmResDownList_Query'
			},
		},
		
};