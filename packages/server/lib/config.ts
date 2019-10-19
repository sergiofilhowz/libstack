import config from 'config';
const cfg = { ...config, ...process.env };

/**
 * The main configuration class
 *
 * @author sergio@filho.org
 */
export class Config {
  innerConfig:any;

  constructor(cfg:any) {
    this.innerConfig = cfg;
  }

  /**
   * Returns a value if it is present
   * @param name
   */
  get(name:string):string {
    return this.innerConfig[name];
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
   */
  getNumber(name:string):number {
    return +this.innerConfig[name];
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