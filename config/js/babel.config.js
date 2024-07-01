module.exports = {
  presets: [
    '@babel/preset-env',
    '@babel/preset-react'
  ],
  plugins: [
    'transform-remove-console'
  ],
  compact: false,
  generatorOpts: {
    retainLines: true,
    compact: false,
    minified: false
  }
};
