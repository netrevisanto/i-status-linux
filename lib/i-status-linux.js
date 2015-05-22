var spawn = require("child_process").spawn;
var shelljs = require("shelljs");
require("colors");
var stringBuilder = require("shelly");
var fs = require("fs");
var extend = require("extend");
module.exports = {
    binario: process.cwd() + '/bin/monitor.sh',
    registrar: function(callback) {
        fs.chmodSync(module.exports.binario, '777');
        return callback();
    },
    read: function(conf, callback) {
        if (typeof conf == "function") {
            callback = conf;
            conf = {};
        }
        var defConf = {
            silent: true
        };
        extend(defConf, conf);
        return module.exports.registrar(function() {
            return module.exports.execute(module.exports.binario, defConf, callback);
        });
    },
    execute: function(command, conf, callback) {
        var processo = spawn(command);
        var retorno = "";
        var err = false;
        if (!conf.silent)
            console.log("Starting collector...".yellow)
        processo.stdout.on("data", function(dados) {

            var resposta = dados.toString('ascii');
            if (!conf.silent)
                console.log(resposta.green);
            retorno += resposta
        });
        processo.stderr.on("data", function(dados) {
            var resposta = dados.toString('ascii');
            if (!conf.silent)
                console.log("Read operation failed!".red, resposta);
            err = resposta;
        });
        processo.on('close', function(code) {
            if (err) {
                return callback(err, null);
            } else {
                return callback(null, JSON.parse(retorno));
            }
        });
    }

}