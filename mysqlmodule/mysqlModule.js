var exports = module.exports = {};

var mysql = exports.mysql = require('mysql');

var connection = exports.connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'boaw_db'
});

// Login Insert Accounts
// Checkt, ob User schon in der Datenbank, falls nicht, dann wird der neue User hinzugefügt
//Shakil was here :)
//This is a Test to seee how merging in GitHub works :D
exports.loginCheck = function (sEmail,sVname,sNname,sKlasse,callback) {
    connection.query('insert into schueler select * From (select "?","?","?","?","0") as daten where not EXISTS ( Select sEmail from schueler where sEmail="?") limit 1 ',sEmail,sVname,sNname,sKlasse,sEmail, function(err,rows,fields){
        if(err) throw err;

        return callback(rows,err);
    });
};

//Unsicher Injection

exports.erstelleKursLehrer = function(email,kBez,kBeschr,minL,maxL,minS,maxS,Tag,ZAnf,ZEnd,callback) {
    connection.query('Call erstelleKurs(?,"?","?",?,?,?,?,"?","?","?")',id,kBez,kBeschr,minL,maxL,minS,maxS,Tag,ZAnf,ZEnd, function(err,rows,fields){
        if(err) throw err;

        return callback(rows,err);
    });
};


exports.selectKurs = function(id,email,callback){
    connection.query('select k.kID,kBezeichnung,kBeschreibung,minSchueler,maxSchueler,Tag,time_format(ZeitAnfang,\'%H:%i\') as ZeitAnfang,time_format(ZeitEnde,\'%H:%i\') as ZeitEnde,s.sEmail,tdatum,twochentag,tid from kurse k left join kurse_wann kw using(kID) left join schueler_hat_kurse s using(kID) left join tage t on kw.Tag = t.tid where s.sEmail = "?" and k.kID = "?"',email,id,function (err,rows) {
        if(err) throw err;

        return callback(rows,err);
    });
};

exports.selectAngeboteneKurse = function(email,callback){
    connection.query('select k.kID,kBezeichnung,kBeschreibung,minSchueler,maxSchueler,Tag,time_format(ZeitAnfang,\'%H:%i\') as ZeitAnfang,time_format(ZeitEnde,\'%H:%i\') as ZeitEnde,s.sEmail,date_format(tdatum,\'%d.%m.%y\'),twochentag,tid from kurse k left join kurse_wann kw using(kID) left join schueler_hat_kurse s using(kID) left join tage t on kw.Tag = t.tid where kID != all (select kID from schueler_hat_kurse where sEmail="?") and k.deleted != 1 ',email, function(err, rows, fields){
        if(err) throw err;

        return callback(rows);
    });
};

exports.selectKurseLehrer = function(email,callback) {
        connection.query('select * from lehrer_macht_kurse join kurse using(kID) where lEmail="?" and kurse.deleted!=1',email, function (err, rows, fields) {
            if (err) throw err;

            return callback(rows);
        });
};

exports.selectAngeboteneKurseLehrer = function(email,callback){
    connection.query('select k.kID, kBezeichnung, kBeschreibung, minSchueler, maxSchueler, Tag, time_format(ZeitAnfang,\'%H:%i\') as ZeitAnfang, time_format(ZeitEnde,\'%H:%i\') as ZeitEnde ,s.lEmail, date_format(tdatum,\'%d.%m.%y\'), twochentag, tid from kurse k left join kurse_wann kw using(kID) left join lehrer_macht_kurse s using(kID) left join tage t on kw.Tag = t.tid where kID != all (select kID from lehrer_macht_kurse where lEmail="?") and k.deleted != 1',email, function(err, rows, fields){
        if(err) throw err;

        return callback(rows);
    });
};

// date_format(kStartDatum,\'%d.%m.%y\')
// date_format(kEndDatum,\'%d.%m.%y\')
// time_format(kStartZeit,\'%H:%i\')
// time_format(kEndZeit,\'%H:%i\')

exports.selectKurseSchueler = function(email,callback) {
    connection.query('select k.kID,kBezeichnung,kBeschreibung,minSchueler,maxSchueler,Tag,time_format(ZeitAnfang,\'%H:%i\') as ZeitAnfang,time_format(ZeitEnde,\'%H:%i\') as ZeitEnde,s.sEmail,date_format(tdatum,\'%d.%m.%y\'),twochentag,tid from kurse k left join kurse_wann kw using(kID) left join schueler_hat_kurse s using(kID) left join tage t on kw.Tag = t.tid where s.sEmail = "?" and k.deleted != 1 ',email, function (err, rows, fields) {
        if (err) throw err;

        return callback(rows);
    });
};

exports.fullReset = function(callback){
  connection.query('call fullReset()',function(err, rows, fields){
      if (err) throw err;

      return callback();
  });
};

exports.dateReset = function(callback){
    connection.query('delete from tage',function(err, rows, fields){
        if (err) throw err;

        return callback();
    });
};

exports.firstLogin = function (email, vname, nname, callback) {
    connection.query('INSERT INTO schueler (sEmail, sVorname, sNachname, sKlasse, deleted) SELECT * FROM (SELECT "?","?", "?", '+'NULL'+', 0) AS tmp WHERE NOT EXISTS (SELECT sEmail FROM schueler WHERE sEmail = "?") LIMIT 1;',email,vname,nname,email, function(err, rows, fields){
        if(err) throw err;

        return callback();
    });
};

exports.firstLoginLehrer = function (email, vname, nname, callback) {
    connection.query('INSERT INTO lehrer (lEmail, lVorname, lNachname, deleted) SELECT * FROM (SELECT "?","?", "?", 0) AS tmp WHERE NOT EXISTS (SELECT lEmail FROM lehrer WHERE lEmail = "?") LIMIT 1;',email,vname,nname,email, function(err, rows, fields){
        if(err) throw err;

        return callback();
    });
};

exports.setWoche = function (startDatum, endDatum, callback){
    connection.query('call ProjektWochenInsert(\'?\',\'?\')',startDatum,endDatum, function (err, rows, fields) {
        if(err) throw err;

        return callback();
    });
};

exports.selectProjektWoche = function (callback){
    connection.query('call selectWocheVonBis()', function (err, rows, fields) {
        if(err) throw err;

        return callback(rows);
    });
};

exports.schuelertraegtfuerkursein = function (schuelermail,kursid,callback){
    connection.query('INSERT INTO `schueler_hat_kurse`(`sEmail`, `kID`) VALUES (?,?)',schuelermail,kursid, function (err, rows, fields) {
        if(err) throw err;

        return callback(rows);
    });
};