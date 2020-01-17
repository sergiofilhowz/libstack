import Bluebird from 'bluebird';
import { DataApi, DataApiConnection } from './DataApi';

export class DataApiConnectionManager {
  constructor(private readonly dataApi: DataApi) {}

  refreshTypeParser(DataTypes: any) {}

  getConnection(options: any): Bluebird<DataApiConnection> {
    return Bluebird.resolve(new DataApiConnection(this.dataApi));
  }

  releaseConnection(): void {}

  close() {}
}