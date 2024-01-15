module.exports = {
  root: true,
  extends: ['universe/native', 'universe/web'],
  ignorePatterns: ['build'],
  rules: {
    'no-undef': ['error', { __dirname: true }],
  },
};
