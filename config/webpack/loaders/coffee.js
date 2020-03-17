module.exports = {
  test: /\.coffee$/,
  use: [{
    loader: 'coffee-loader'
  }]
};


module.rules = [
    { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
  ];
