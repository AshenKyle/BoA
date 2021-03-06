var express = require('express');
var router = express.Router();
var moment = require('moment');
var mysql = require('../mysqlmodule/mysqlModule');

/* GET home page. */

var d = new Date();
var wochentag = new Array(7);
wochentag[0]=  "Sonntag";
wochentag[1] = "Montag";
wochentag[2] = "Dienstag";
wochentag[3] = "Mittwoch";
wochentag[4] = "Donnerstag";
wochentag[5] = "Freitag";
wochentag[6] = "Samstag";

var n = wochentag[d.getDay()];

router.get('/', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_home',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});

router.get('/detail/:id', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_detail',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});

router.post('/:id', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_home',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});

router.post('/', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_home',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});

router.delete('/:id', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_home',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});

router.put('/:id', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_home',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});


router.put('/bearbeiten/:id', function(req, res, next) {
    var x = 710;
    for(var i=0; i<kurseLehrer.length;i=i+4){ x+=180; }
    for(var i=0; i<angeboteneKurseLehrer.length;i=i+4) { x+=180; }
    res.render('l_home',
        {
            dateNow: moment().format('DD.MM.YYYY'),
            wochentag: n,
            jumbotronheight: x
        });
});

module.exports = router;
