/**
 * New Relic agent configuration.
 *
 * See lib/config.defaults.js in the agent distribution for a more complete
 * description of configuration variables and their potential values.
 */
exports.config = {
  /**
   * Array of application names.
   */
  app_name : ['nodesphere'],
  /**
   * Your New Relic license key.
   */
  license_key : '7cad9c8b24c8d7eaa74101d66179abdfe38da9a9',
  logging : {
    /**
     * Level at which to log. 'trace' is most useful to New Relic when diagnosing
     * issues with the agent, 'info' and higher will impose the least overhead on
     * production applications.
     */
    level : 'warn'  // fatal, error, warn, info, debug, or trace
  }
};
