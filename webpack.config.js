var path = require('path')
var webpack = require('webpack')

module.exports = {
  //devtool: 'cheap-module-eval-source-map',
  // devtool: 'source-map',
  devtool: 'eval',
  debug: true,

  entry: [
    // 'webpack-hot-middleware/client',
    './src/index.coffee'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'nodesphere.js',
    // publicPath: '/static/'
  },
  plugins: [
    // new webpack.optimize.OccurenceOrderPlugin(),
    // new webpack.HotModuleReplacementPlugin(),
    // new webpack.NoErrorsPlugin()
  ],
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
      },
      {
        test: /\.js$/,
        // loaders: [ 'babel' ],
        exclude: /node_modules/,
        include: __dirname
      }
    ]
  },
  node: {
    child_process: "empty",
    // net: "empty",
    // tls: "empty",
    fs: "empty"
  },
  resolve: {
    extensions: ['', '.coffee', '.js', '.json', ".webpack.js"]
  }
}
