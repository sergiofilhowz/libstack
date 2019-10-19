interface PropertyOptions {
  property?: string;
}

export function Property(target: Function): void;
export function Property(options: PropertyOptions): Function;
export function Property(target: any, propertyName: string, propertyDescriptor?: PropertyDescriptor): void;
export function Property(...args: any[]): void | Function {
  if (args.length >= 2) {
    const target = args[0];
    const propertyName = args[1];
    const propertyDescriptor = args[2];

    property(target, propertyName, propertyDescriptor);
    return;
  }

  return (target: any, propertyName: string, propertyDescriptor?: PropertyDescriptor) => {
    property(target, propertyName, propertyDescriptor);
  };
}

function property(target: any, propertyName: string, propertyDescriptor: PropertyDescriptor) {

}