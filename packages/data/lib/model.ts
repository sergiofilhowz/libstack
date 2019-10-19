import { ModelCtor } from 'sequelize-typescript';

export interface SingleOptions<T> {
  projection: { new(): T; };
  criteria?: object;
}

export interface ListOptions<T> extends SingleOptions<T> {
  sort?: string;
  pageSize?: number;
}

export interface PageOptions<T> extends ListOptions<T> {
  page: number;
}

export class Page<T> {
  list: Array<T>;
  count: number;

  constructor(list: Array<T>, count:number) {
    this.list = list;
    this.count = count;
  }
}

export class Model {
  constructor(private model:ModelCtor) {}

  async list<T>(options:ListOptions<T>):Promise<Array<T>> {
    return [];
  }
  async page<T>(options:PageOptions<T>):Promise<Page<T>> {
    return new Page([], 0);
  }
  async single<T>(options:SingleOptions<T>):Promise<T> {
    return null;
  }
}