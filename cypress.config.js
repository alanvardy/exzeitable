module.exports = {
  e2e: {
    testIsolation: false,
    setupNodeEvents(on, config) {
      return require('./cypress/plugins/index.js')(on, config)
    },
  },
}
