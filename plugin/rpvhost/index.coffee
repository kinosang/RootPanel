{path, fs} = app.libs
{pluggable, config} = app
{Plugin} = app.interfaces

rpvhostPlugin = module.exports = new Plugin
  name: 'rpvhost'

  register_hooks:
    'view.layout.menu_bar':
      href: 'http://blog.rpvhost.net'
      target: '_blank'
      t_body: 'official_blog'

    'plugins.wiki.pages':
      category: 'rpvhost'
      name: 'Terms.md'
      t_category: ''
      t_title: 'terms'
      language: 'zh_CN'
      content_markdown: fs.readFileSync("#{__dirname}/wiki/Terms.md").toString()

    'billing.payment_methods':
      type: 'taobao'

      widgetGenerator: (req, callback) ->
        rpvhostPlugin.render 'payment_method', req, {}, callback

      detailsMessage: (req, deposit_log, callback) ->
        callback rpvhostPlugin.getTranslator(req) 'view.payment_details',
          order_id: deposit_log.payload.order_id

    'view.layout.styles':
      register_if: -> @config.green_style
      path: '/plugin/rpvhost/style/green.css'

  initialize: ->
    unless @config.index_page == false
      app.express.get '/', (req, res) =>
        @render 'index', req, {}, (html) ->
          res.send html
