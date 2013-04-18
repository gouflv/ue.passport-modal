# Passport Modal

> 通用弹窗登录

## 使用

### 准备
该组建依赖Passport-1.0, 因此需要在页面引入

`<script src="http://ue8.17173.itc.cn/cache/lib/v2/passport-1.0/loader.js"></script>`

然后加入该弹窗组建
`<script src="js/passport-modal.coffee.js"></script>`

### 调用方式
打开弹窗 `$.passport_modal()`

> 初始化弹窗以及Passport, 并会默认直接显示弹窗, 功能等同于`$.passport_modal('show')`

> 会自动插入body一个默认弹窗元素 `#component_passport_modal`, 如需自定义弹窗元素, 请参考自定义配置小节

关闭弹窗 `$.passport_modal('hide')`

### 参数配置
`$.passport_modal()` 方法可接收配置

>提供 `onLoginSuccess`, `onLoginFailure`, `onLogoutSuccess` 等回掉参数, 功能于Passport保持一致, [详见文档]()

实例

	$.passport_modal({
		onInit: function() { alert('init.') }
	})
	
	
## 样式定制


