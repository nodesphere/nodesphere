var path = require('path')
var webpack = require('webpack')

module.exports = {
  //devtool: 'cheap-module-eval-source-map',
  // devtool: 'source-map',
  // devtool: 'eval',
  // debug: true,

  entry: [
    // 'webpack-hot-middleware/client',
    './src/index.coffee'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'nodesphere.js',
    library: 'Nodesphere'
    // publicPath: '/static/'
  },
  resolve: {
    modulesDirectories: [
      'node_modules'
    ],
    alias: {
      http: 'stream-http',
      https: 'https-browserify'
    },
    extensions: ['', '.coffee', '.js', '.json', ".webpack.js"]
  },
  module: {
    noParse: [
      /node_modules\/coffee-script/,
      /node_modules\/require-dir/
    ],
    loaders: [
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      },
      {
        test: /\.json$/,
        loader: "json-loader"
      }
    ]
  },
  externals: {
    child_process: '{}',
    net: '{}',
    fs: '{}',
    tls: '{}',
    console: '{}',
    'require-dir': '{}'
  },
  timeout: 60000,
  plugins: [
    // new webpack.optimize.OccurenceOrderPlugin(),
    // new webpack.HotModuleReplacementPlugin(),
    // new webpack.NoErrorsPlugin()
  ]
}
