import path from 'path';
import nodeExternals from 'webpack-node-externals';
import { __dirname,  } from './utils.mjs';
import webpack from 'webpack';

const config = {
  entry: './src/app.ts',
  target: 'node',
  mode: 'development',
  externals: [nodeExternals()], // Exclude node_modules
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, 'dist'),
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('development'),
    }),
  ],
};

export default config;