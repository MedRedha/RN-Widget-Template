const ERROR = 2;

module.exports = {
  root: true,
  extends: '@react-native-community',
  rules: {
    'no-console': ERROR,
    'jsx-quotes': ['error', 'prefer-single'],
    quotes: [2, 'single', { avoidEscape: true }],
    'simple-import-sort/imports': 'error',
  },
  plugins: ['simple-import-sort'],
};
