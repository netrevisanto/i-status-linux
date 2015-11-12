//module.exports = require("./lib/i-status-linux");

var st = require("./lib/i-status-linux");
var util = require('util');

st.read(function(err, succ) {
    console.log(util.inspect(succ, {
        colors: true
    }));
});

/*
SELECT USENAME AS USERNAME, CLIENT_ADDR AS IP, WAITING AS ESPERANDO, CURRENT_QUERY AS QUERY, EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - BACKEND_START))::INTEGER AS TEMPOEXECUCAO  FROM PG_STAT_ACTIVITY;
SELECT T1.DATNAME AS NOMEBASE, PG_DATABASE_SIZE(T1.DATNAME) AS TAMANHO FROM PG_DATABASE T1 WHERE T1.DATNAME='?', base;
*/