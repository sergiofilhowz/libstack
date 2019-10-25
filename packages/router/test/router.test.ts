import chai from 'chai';
import chaiHttp from 'chai-http';
import server from './server';

chai.should();
chai.use(chaiHttp);

describe('Express Power Router', () => {
  it('should return the result from a promise', (done) => {
    chai.request(server)
      .get('/myController')
      .end((err, res) => {
        res.should.have.status(200);
        res.body.should.have.property('result').equal('I can return a promise!');
        res.body.should.have.property('anotherResult').equal('The result has been changed!');
        done();
      });
  });

  it('should get result with res.end() call', (done) => {
    chai.request(server)
      .get('/myController/customEnd')
      .end((err, res) => {
        res.should.have.status(200);
        res.text.should.equal('my custom end');
        done();
      });
  });

  it('should throw 404 on NotFoundError', (done) => {
    chai.request(server)
      .get('/myController/throw404')
      .end((err, res) => {
        res.should.have.status(404);
        res.body.should.have.property('message').equal('Pretend I don\'t exist');
        done();
      });
  });

  it('should throw 400 on BadRequestError', (done) => {
    chai.request(server)
      .post('/myController/throwError')
      .end((err, res) => {
        res.should.have.status(400);
        res.body.should.have.property('message').equal('My error message');
        done();
      });
  });
});