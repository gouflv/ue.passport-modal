# Passport Modal

> 提供通用样式的弹窗登录

Click [Demo](example/demo1.html)

## 使用

### 准备
1.该组建依赖 Passport-1.0, 因此需要在页面引入
`<script src="http://ue8.17173.itc.cn/cache/lib/v2/passport-1.0/loader.js"></script>`

2.然后加入该弹窗组建
`<script src="http://ue8.17173.itc.cn/cache/lib/v2/passport-modal-1.0/passport-modal.min.js"></script>`

3.创建用户信息模板

> 用户登录后显示的用户信息面板暂时不提供通用样式, 因此需要提供相应模板
> 该模板参照Passport的元素渲染规则, 详细参考**自定义外观指南**的 `infoElement`小节

默认读取 `#component_passport_info_tmpl` 元素作为用户信息模板

模板直接放在用户信息面板的容器内, 组件将自动将渲染后显示模板

	<div class="userinfo_wrap">
	
		<div class="info-box hidden" id="component_passport_info_tmpl">
			<div>自定义用户信息</div>
			<div class="logout-err"></div>
			<div class="portrait"></div>
			<div class="username"></div>
			<div class="nickname"></div>
			<a class="logout-btn">注销</a>
		</div>
	</div>

### 调用方式
1. 初始化弹窗 `$.passport_modal(option)`, 可以传入配置参数

2. 显示弹窗 `$.passport_modal('show')`

3. 关闭弹窗 `$.passport_modal('hide')`

### 参数配置
> 事件回调

`$.passport_modal({...})`

提供 `onLoginSuccess`, `onLoginFailure`, `onLogoutSuccess` 等回掉参数, 功能与Passport保持一致, [详见文档]()

实例

	$.passport_modal({
		onInit: function() { alert('init.') }
	})
	

#### APIs
`onLoginSuccess` 方法内注入passport参数, 用于直接操作passport

	$.passport_modal({
		onLoginSuccess: function(pspt) {
			//获取用户登录信息
			console.log(pspt.data('....'))
		}
	})


	
## 样式定制

Click [Demo](example/demo2.html)

预先在页面内提供 `#component_passport_modal` 元素即可让组建直接使用

可复用外层定位元素 `.passport-modal`, 定制内部元素参考**自定义外观指南**

	

## URL
源码
	
	http://svn.17173.com/svn/ue-lib/ue.passport-modal

线上发布资源

	http://ue8.17173.itc.cn/cache/lib/v2/passport-modal-1.0/passport-modal.min.js
	http://ue8.17173.itc.cn/cache/lib/v2/passport-modal-1.0/passport-modal.min.css

> 样式由脚本自动引入

---
wenhuilv [lv.gouf@gmail.com]