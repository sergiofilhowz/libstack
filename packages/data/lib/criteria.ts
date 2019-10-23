import { QueryBuilder } from './query/query.builder';

export type Expression = (expr: string | Expression, ...params: any[]) => void;
export type Operator = (expression:Expression, property:string, value?: any, queryBuilder?:QueryBuilder<any>) => void;

export interface CriteriaOptions {
  /**
   * The property to be used in the criteria
   */
  property?: string;

  /**
   * The operator to be executed on this criteria
   */
  operator: Operator;

  /**
   * Value to be compared
   */
  value?: any;
}

/**
 * Criterias are meant for filtering values
 */
export function Criteria(options: CriteriaOptions): Function {
  return (target: any, propertyName: string) => criteria(target, propertyName, options);
}

export interface CriteriaFieldConfiguration {
  field: string;
  propertyType: any;
  modelProperty: string;
  options: CriteriaOptions;
}

export interface CriteriaConfiguration {
  fields: CriteriaFieldConfiguration[];
}

function criteria(target: any, propertyName:string, options: CriteriaOptions) {
  if (!Reflect.hasMetadata('criteria', target)) {
    Reflect.defineMetadata('criteria', {
      fields: [],
    }, target);
  }

  const propertyType = Reflect.getMetadata('design:type', target, propertyName);
  const criteria:CriteriaConfiguration = Reflect.getMetadata('criteria', target);
  criteria.fields.push({
    field: propertyName,
    propertyType,
    modelProperty: options && options.property || propertyName,
    options
  });
}