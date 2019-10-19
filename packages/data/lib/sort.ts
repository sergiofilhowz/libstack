/*
 * Still work in progress
 */

enum Direction {
  ASC,
  DESC
}

interface SortOptions {
  name: string;
  property: string;
  direction: Direction;
}

export function Sorts(options:Array<SortOptions>):Function {
  // if (typeof arg === 'function') {
  //   property(arg);
  // } else {
  return (target: any) => sort(target, options);
  // }
}


function sort(target:any, options:SortOptions []) {

}