var express = require("express");
var low = require("lowdb");
var FileSync = require("lowdb/adapters/FileSync");
var adapter = new FileSync(".data/db.json");
var db = low(adapter);
var app = express();
var bodyParser = require('body-parser')
var path = require('path')

var scores_to_add = [];
var scores_to_update = [];

app.use(express.static('public'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*"); // TODO: update to redhat url when live
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

db.defaults({ scores: [
  {"id":1,  "persona":1, "products":6, "initials":"ONE", "score":100 , "time":-1 },
  {"id":2,  "persona":0, "products":2, "initials":"TWO", "score":90  , "time":-1 },
  {"id":3,  "persona":2, "products":0, "initials":"TRE", "score":80  , "time":-1 },
  {"id":4,  "persona":1, "products":7, "initials":"FOR", "score":70  , "time":-1 },
  {"id":5,  "persona":2, "products":2, "initials":"FIV", "score":60  , "time":-1 },
  {"id":6,  "persona":0, "products":4, "initials":"SIX", "score":50  , "time":-1 },
  {"id":7,  "persona":1, "products":3, "initials":"SVN", "score":40  , "time":-1 },
  {"id":8,  "persona":0, "products":6, "initials":"EHT", "score":30  , "time":-1 },
  {"id":9,  "persona":2, "products":5, "initials":"NIN", "score":20  , "time":-1 },
  {"id":10, "persona":0, "products":1, "initials":"TEN", "score":10  , "time":-1 },
] }).write();

app.use('/scores', (req, res) => {
  var dbscores=[];
  var scores = db.get('scores').orderBy('score', 'desc').take(10).value();
  scores.forEach((score) => {
    dbscores.push(score);
  });
  res.send(dbscores);
});

app.use('/all-scores', (req, res) => {
  var dbscores=[];
  var scores = db.get('scores').orderBy('score', 'desc').value();
  scores.forEach((score) => {
    dbscores.push(score);
  });
  res.send(dbscores);
});

var blacklist = [
  'FAG',
	'NIG',
	'NGR',
	'FUK',
	'CUM',
	'KKK',
	'FUX',
	'FGT',
	'ASS',
	'SEX',
];

function verify(data) {
  if (!data.id || !data.score || data.persona == undefined || !data.initials || data.products == undefined || !data.time) {
    console.log(`Bad Data! data missing required element`);
    return false;
  }
  if (data.initials.length != 3) {
    console.log(`Bad Data! incorrect initials`);
    return false;
  }
  if (blacklist.indexOf(data.initials) >= 0) {
    console.log(`Bad Data! initials in blacklist`);
    return false;
  }
  if (data.products < 0 || data.products > 7) {
    console.log(`Bad Data! incorrect products`);
    return false;
  }
  if (data.score/data.time > 10) {
    console.log(`Bad Data! impossible score`);
    return false;
  }
  return true;
}

app.post('/post-score', (req, res) => {
  res.sendStatus(200);
  
  let body = JSON.parse(req.body.body);
  
  // verify data
  if (!verify(body)) {
    console.log('verification failed, trashing', body);
    return;
  }
  
  // check to see if id is present in db already
  let current = db.get('scores').find({id:body.id}).value();
  if (current) {
    console.log('id present...updating data');
    console.log(db.get('scores').find({id:body.id}).assign({
      score:Math.max(current.score, body.score),
      initials:body.initials,
      persona: body.persona,
      products: body.products,
      time: body.time,
    }).value());
    return;
  }
  
  scores_to_add.push(body);
  return;
  
  db.get('scores')
    .push(body)
    .write();
  console.log('new score added to database');
});

app.get('/reset', (req, res) => {
  db.get('scores')
    .remove()
    .write();
  console.log('Database cleared');
  
  var scores = [
    {"id":1,  "persona":1, "products":6, "initials":"ONE", "score":100 , "time":-1 },
    {"id":2,  "persona":0, "products":2, "initials":"TWO", "score":90  , "time":-1 },
    {"id":3,  "persona":2, "products":0, "initials":"TRE", "score":80  , "time":-1 },
    {"id":4,  "persona":1, "products":7, "initials":"FOR", "score":70  , "time":-1 },
    {"id":5,  "persona":2, "products":2, "initials":"FIV", "score":60  , "time":-1 },
    {"id":6,  "persona":0, "products":4, "initials":"SIX", "score":50  , "time":-1 },
    {"id":7,  "persona":1, "products":3, "initials":"SVN", "score":40  , "time":-1 },
    {"id":8,  "persona":0, "products":6, "initials":"EHT", "score":30  , "time":-1 },
    {"id":9,  "persona":2, "products":5, "initials":"NIN", "score":20  , "time":-1 },
    {"id":10, "persona":0, "products":1, "initials":"TEN", "score":10  , "time":-1 },
  ];
  scores.forEach((score) => {
    db.get('scores')
      .push({ "id":score.id,  "persona":score.persona, "products":score.products, "initials":score.initials, "score":score.score, "time": score.time })
      .write();
  });
  console.log('default scores added');
  res.redirect('/');
});

app.get('dashboard', (req, res) => {
  res.sendFile('/dashboard.html');
});

var listener = app.listen(process.env.PORT, () => {
  console.log(`app listening on port ${listener.address().port}`);
});

function batch_push() {
  if (scores_to_add.length == 0) return;
  console.log(`Adding ${scores_to_add.length} scores...`);
  db.get('scores')
      .push(...scores_to_add)
      .write();
  scores_to_add = [];
}

setInterval(() => batch_push(), 1000);