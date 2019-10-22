import 'reflect-metadata';

export interface ProjectionOptions {
  sorted?: boolean
}

export function Projection(target: Function): void;
export function Projection(options: ProjectionOptions): Function;
export function Projection(options?: any): void | Function {
  if (typeof options === 'function') {
    projection(options);
  } else {
    return (target: any) => projection(target, options);
  }
}

export interface ProjectionConfiguration {
  properties: PropertyConfiguration[];
  options?: ProjectionOptions;
}

function projection(target:any, options?:ProjectionOptions) {
  if (!Reflect.hasMetadata('projection', target.prototype)) {
    Reflect.defineMetadata('projection', {
      properties: [],
      options: options || {}
    }, target);
  } else {
    const projection:ProjectionConfiguration = Reflect.getMetadata('projection', target.prototype);
    projection.options = options;
    Reflect.defineMetadata('projection', projection, target);
  }
}

type JoinType = 'left' | 'right';

export interface PropertyOptions {
  property?: string;
  joinType?: JoinType;
}

export interface PropertyConfiguration {
  propertyType: any;
  projectionProperty: string;
  modelProperty: string;
  options?: PropertyOptions;
}

export function Property(target: Function): void;
export function Property(options: PropertyOptions): Function;
export function Property(target: any, propertyName: string, propertyDescriptor?: PropertyDescriptor): void;
export function Property(...args: any[]): void | Function {
  if (args.length >= 2) {
    const target = args[0];
    const propertyName = args[1];

    property(target, propertyName);
    return;
  }

  return (target: any, propertyName: string) => {
    property(target, propertyName, args[0]);
  };
}

function property(target: any, propertyName: string, options?:PropertyOptions) {
  if (!Reflect.hasMetadata('projection', target)) {
    Reflect.defineMetadata('projection', {
      properties: [],
      options: {}
    }, target);
  }

  const type = Reflect.getMetadata('design:type', target, propertyName);
  const projection:ProjectionConfiguration = Reflect.getMetadata('projection', target);
  projection.properties.push({
    projectionProperty: propertyName,
    modelProperty: options && options.property || propertyName,
    propertyType: type,
    options
  });
}