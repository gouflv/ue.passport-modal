root = this
$ = jQuery
isIE6 = $.browser.msie and parseInt($.browser.version) is 6


unless root.console
	do ->
		methods = ['assert', 'debug', 'dir', 'error', 'grounp', 'grounpEnd', 'log', 'warn']
		console = root.console = {}
		$.each methods, (i,name) -> console.name = $.noop


class Modal
	constructor: (@el, @option={}) ->
		@el = $ @el
		this.init_element()
			.init_event()
			.render_passport()
		
	init_element: () ->
		@el.appendTo document.body
		this
	
	init_event: () ->
		@el.delegate '[data-dismiss="modal"]', 'click.dismiss.modal', (e) => this.hide(e)
		this
		
	show: () ->
		return this if @isShow
		@isShow = true

		e = $.Event 'show'
		@el.trigger e

		this.create_backdrop() if @option.backdrop

		@el.addClass('in')
			.show()

		this.pos()

		# disable viewport scroll
		$('html,body').addClass 'no-scroll'

		@el.find('input:first').focus()

		this
		
	hide: () ->
		return this unless @isShow
		@isShow = false

		e = $.Event 'hide'
		@el.trigger e

		@el.removeClass('in')
			.hide()

		$('html,body').removeClass 'no-scroll'

		this.remove_backdrop()

		this
		
	create_backdrop: () ->
		if @isShow
			$w = $ window

			@backdrop = $('<div/>', {
					class: 'passport-modal-backdrop'
				}).appendTo document.body

			@backdrop.click (e) =>
				e.preventDefault()
				@el.eq(0).focus()

			if isIE6
				@backdrop.css {width: $w.width(), height: $(document).height()}

		unless @isShow
			@backdrop.fadeOut 200, () =>
				this.remove_backdrop()
			
		this
	
	remove_backdrop: () ->
		@backdrop?.remove()
		@backdrop = null
		this

	pos: () ->
		if isIE6
			_h = $(window).height()
			_stop = $('html,body').scrollTop()
			top = _h * 0.18 + _stop

			@el.css 'top', top
	

	render_passport: () ->
		@passport = @el.data 'passport'
		_this = this

		config =
			element: @el.get(0)
			ui: 'none'
			onInit: @option.onInit
			onLoginStart: @option.onLoginStart
			onLoginSuccess: () ->
				# push passport object manually
				# TODO: make a param warper util to all event callback
				pspt = this
				_this.login_success_wraper.call _this, pspt

			onLoginFailure: @option.onLoginFailure
			onLogoutStart: @option.onLogoutStart
			onLogoutSuccess: @option.onLogoutSuccess
			onLogoutFailure: @option.onLogoutFailure

		unless @passport
			timer = setInterval =>
				if root.modules and root.modules.config
					clearInterval(timer)
					this.loader(config)
			, 10

	loader: (config) ->
		require ['passport'], (Passpost) =>
			@el.data 'passport', (@passport = new Passpost(config))

	login_success_wraper: (pspt) ->				
		info = @el.find('.info-box').addClass 'is-login'
		ctx = $('#component_passport_info_tmpl')
		# ctx.parent().find('.is-login').remove()
		info.insertAfter ctx
		
		this.hide()

		@option.onLoginSuccess?.call this, pspt
	

$.fn.passport_modal = (option={}) ->	
	this.each () ->
		$this = $ this
		data = $this.data 'passport_modal'
		options = $.extend {}, $.fn.passport_modal.defaults, typeof option is 'object' and option
		
		unless data
			$this.data 'passport_modal', (data = new Modal(this, options))

		if typeof option is 'string'
			data[option]()
		else
			# show by default
			data.show() if options.show

$.passport_modal = (option={}) ->
	el = $ '#component_passport_modal'
	unless $('#component_passport_modal').size()
		$(document.body).append modal_element
		el = $ '#component_passport_modal'

		info_box = $('#component_passport_info_tmpl').clone()
		info_box.removeAttr 'id'
		el.find('.form-box').parent().append info_box

	el.passport_modal option


$.fn.passport_modal.defaults =
	backdrop: true
	show: false	
	ui: 'none'
	onInit: $.noop
	onLoginStart: $.noop
	onLoginSuccess: $.noop
	onLoginFailure: $.noop
	onLogoutStart: $.noop
	onLogoutSuccess: $.noop
	onLogoutFailure: $.noop


load_css = () ->
	return if $('#passport-modal-style').size()
	url = 'http://ue8.17173.itc.cn/cache/lib/v2/passport-modal-1.0/passport-modal.min.css'
	css = '<link rel="stylesheet" href="' + url + '"></link>'
	$('head').append $(css)

load_css()

modal_element = '<div id="component_passport_modal" class="passport-modal hidden"><div class="modal-box-wrap"><div class="modal-box"><div class="modal-tab clearfix"><span class="modal-close" data-dismiss="modal"></span><ul><li class="modal-tab-item current"><a href="#sign_in">登录</a><b class="modal-tab-item-b1"></b><b class="modal-tab-item-b2"></b></li><li class="modal-tab-item"><a href="http://passport.17173.com/register" target="_blank">注册</a><b class="modal-tab-item-b1"></b><b class="modal-tab-item-b2"></b></li></ul></div><div class="modal-main-wrap"><div class="modal-main" data-switch="sign_in"><form method="post" class="modal-form form-box" autocomplete="off"><div class="item item-1"><label class="tit">用户名</label><input name="email" value="" type="text" class="txt" autocomplete="off" disableautocomplete /></div><div class="item item-2"><label class="tit">密  码</label><input name="password" type="password" value=""  class="txt" autocomplete="off" disableautocomplete /></div><div class="item item-3"><div class="item-3-c1"><input name="persistentcookie" type="checkbox" value="1"  class="auto-checkbox" id="passport_auto_login" /><label for="passport_auto_login">自动登录</label></div><a href="http://passport.17173.com/find" target="_blank" class="forget">忘记密码？</a></div><div class="item item-4"><button type="submit" class="login-btn modal-btn-signin">登录</button></div></form><div class="modal-waitting-box wait-box hidden"><span class="logging-in">正在登录, 请稍候...</span><span class="logging-out">正在注销, 请稍候...</span></div></div><div class="modal-main hidden" data-switch="register"></div></div></div></div></div>'
