export interface ProjectionOptions {
  sorted: boolean
}

export function Projection(target: Function): void;
export function Projection(options: ProjectionOptions): Function;
export function Projection(options?: any): void | Function {
  if (typeof options === 'function') {
    projection(options);
  } else {
    return (target: any) => projection(target);
  }
}

function projection(target:any) {

}