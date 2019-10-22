type Operator = (expression:any, property:string, value: any) => void;

export interface CriteriaOptions {
  /**
   * The property to be used in the criteria
   */
  property?: string;

  /**
   * The operator to be executed on this criteria
   */
  operator: Operator;
}

/**
 * Criterias are meant for filtering values
 */
export function Criteria(options: CriteriaOptions): Function {
  return (target: any, propertyName: string) => criteria(target, propertyName, options);
}

function criteria(type: any, propertyName:string, options: CriteriaOptions) {
  type.$criteria = type.$criteria || new Map<string, CriteriaOptions>();
  type.$criteria[propertyName] = {
    property: options.property || propertyName,
    operator: options.operator
  };
}