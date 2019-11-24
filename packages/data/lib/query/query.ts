import { Sequelize, Transaction } from 'sequelize';
import { getBySequelize } from './squel.factory';
import { BaseBuilder, Expression, FieldOptions, Select } from 'squel';
import { Page } from '../model';

export class Query {
  private readonly selectQuery: Select;
  private readonly countQuery: Select;

  private _pageSize: number;
  private _page: number;

  constructor(private sequelize: Sequelize, private transaction?: Transaction) {
    const squel = getBySequelize(sequelize);

    this.selectQuery = squel.select();
    this.countQuery = squel.select().field('0');
  }

  distinct(): this {
    this.selectQuery.distinct();
    return this;
  }

  field(name: string | BaseBuilder, alias?: string, options?: FieldOptions): this {
    this.selectQuery.field(name, alias, options);
    return this;
  }

  fields(fields: { [field: string]: string } | string[], options?: FieldOptions): this {
    this.selectQuery.fields(fields, options);
    return this;
  }

  from(name: string | BaseBuilder, alias?: string): this {
    this.selectQuery.from(name, alias);
    this.countQuery.from(name, alias);
    return this;
  }

  join(name: string | BaseBuilder, alias?: string, condition?: string | Expression): this {
    this.selectQuery.join(name, alias, condition);
    this.countQuery.join(name, alias, condition);
    return this;
  }

  left_join(name: string | BaseBuilder, alias?: string, condition?: string | Expression): this {
    this.selectQuery.left_join(name, alias, condition);
    this.countQuery.left_join(name, alias, condition);
    return this;
  }

  right_join(name: string | BaseBuilder, alias?: string, condition?: string | Expression): this {
    this.selectQuery.right_join(name, alias, condition);
    this.countQuery.right_join(name, alias, condition);
    return this;
  }

  outer_join(name: string | BaseBuilder, alias?: string, condition?: string | Expression): this {
    this.selectQuery.outer_join(name, alias, condition);
    this.countQuery.outer_join(name, alias, condition);
    return this;
  }

  where(condition: string | Expression, ...args: any[]): this {
    this.selectQuery.where(condition, ...args);
    this.countQuery.where(condition, ...args);
    return this;
  }

  having(condition: string | Expression, ...args: any[]): this {
    this.selectQuery.having(condition, ...args);
    this.countQuery.having(condition, ...args);
    return this;
  }

  order(field: string, direction?: boolean | null, ...values: any[]): this {
    this.selectQuery.order(field, direction, ...values);
    return this;
  }

  group(field: string): this {
    this.selectQuery.group(field);
    this.countQuery.group(field);
    return this;
  }

  limit(limit: number): this {
    this.selectQuery.limit(limit);
    return this;
  }

  offset(offset: number): this {
    this.selectQuery.offset(offset);
    return this;
  }

  async getPage(): Promise<Page<any>> {
    const pageSize = this._pageSize;
    const page = this._page;
    const [result, count] = await Promise.all([this.list(), this.count()]);
    return {
      list: result,
      count: count,
      page,
      pages: Math.ceil(count / pageSize)
    };
  }

  size(size: number): this {
    if (size === undefined || size === null) return this;

    this._pageSize = size;
    this.limit(size);
    return this;
  }

  page(page: number, size: number): this {
    this.size(size);
    this._page = page;
    this.offset((page - 1) * size);
    return this;
  }

  async list(): Promise<Array<any>> {
    const { text, values } = this.selectQuery.toParam();
    const [result]: any = await this.sequelize.query(text, {
      replacements: values,
      transaction: this.transaction
    });
    return result;
  };

  async single(): Promise<any> {
    const { text, values } = this.selectQuery.limit(1).toParam();
    const [result]: any = await this.sequelize.query(text, {
      replacements: values,
      transaction: this.transaction
    });
    return result.length ? result[0] : null;
  }

  async count(): Promise<number> {
    const { text, values } = this.countQuery.toParam();
    const query: string = `SELECT COUNT(*) as cnt FROM (${text}) c`;
    const [countResult]: any = await this.sequelize.query(query, {
      replacements: values,
      transaction: this.transaction
    });
    return parseInt(countResult[0].cnt, 10);
  }
}