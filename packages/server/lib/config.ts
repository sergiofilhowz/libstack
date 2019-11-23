import config from 'config';
const cfg = { ...config, ...process.env };
import * as _ from 'lodash';

/**
 * The main configuration class
 *
 * @author Sérgio Marcelino <sergiofilhow@gmail.com>
 */
export class Config {
  innerConfig:any;

  constructor(cfg:any) {
    this.innerConfig = cfg;
  }

  /**
   * Returns a value if it is present
   * @param name
   * @param defaultValue in case there's no value configured
   */
  get(name:string, defaultValue?:string):string {
    const result = this.innerConfig[name];
    return _.isUndefined(result) ? defaultValue : result;
  }

  /**
   * Returns true if there's a param with this name in the config
   * @param name
   */
  has(name:string):boolean {
    return this.innerConfig[name] !== undefined;
  }

  /**
   * Returns true if the param has exactly the value 'true' or boolean true
   * @param name
   */
  getBoolean(name:string):boolean {
    return this.innerConfig[name] === 'true' || this.innerConfig[name] === true
  }

  /**
   * Returns the value as a number
   * @param name
   * @param defaultValue in case there's no value configured
   */
  getNumber(name:string, defaultValue?:number):number {
    const result = this.innerConfig[name];
    if (_.isUndefined(result)) return defaultValue;
    return _.isNumber(result) ? result : _.toNumber(result);
  }

  /**
   * Overrides a variable
   * @param name
   * @param value
   */
  set(name:string, value:string) {
    this.innerConfig[name] = value
  }
}

export default new Config(cfg);