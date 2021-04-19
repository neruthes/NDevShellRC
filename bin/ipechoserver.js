#!/bin/node

const os = require('os');
const fs = require('fs');
const http = require('http');
const uuid = require('uuid');

const ARG_PORT = process.argv[2];

// ----------------------------------------
// Lib functions
// ----------------------------------------

const parseSearchParams = function (rawParams) {
    let obj = {};
    rawParams.split('&').map(function (x) {
        let arr = x.split('=');
        obj[arr[0]] = arr[1];
    });
    return obj;
};
const processRawIpAddr = function (rawipaddr) {
    if (rawipaddr.match(':')) {
        return rawipaddr.replace(/^.+\:/, '');
    } else {
        return rawipaddr;
    };
};

// ----------------------------------------
// Configuration
// ----------------------------------------
const CONFDIR = '/etc/ipechoserver-js';
const GLOBAL_CONFIG = {
    MaxRateMinute: 5
};
let ETC_CONFIG = {};
if (fs.existsSync(`${CONFDIR}/config.json`)) {
    try {
        ETC_CONFIG = JSON.parse(fs.readFileSync(`${CONFDIR}/config.json`).toString());
    } catch (e) {
        console.log(`[ERROR] Config file '${CONFDIR}/config.json' is invalid.`);
    };
} else {
    ETC_CONFIG.TokenMaster = uuid.v4();
    fs.mkdirSync(CONFDIR, { recursive: true });
    fs.writeFileSync(`${CONFDIR}/config.json`, JSON.stringify(ETC_CONFIG, '\t', 4));
};
Object.keys(ETC_CONFIG).map(x => GLOBAL_CONFIG[x] = ETC_CONFIG[x]);
console.log(GLOBAL_CONFIG);

// ----------------------------------------
// Runtime Variables
// ----------------------------------------
let RT_RateLimitTable = {};

// ----------------------------------------
// Watchdogs
// ----------------------------------------
setInterval(function () {
    RT_RateLimitTable = {};
}, 1000*60);

// ----------------------------------------
// Main logic
// ----------------------------------------
http.createServer(function (req, res) {
    let parsedParams = {};
    if (req.url.indexOf('?') !== -1) {
        // Search params found
        let reqPath = req.url.split('?')[0];
        let rawParams = req.url.split('?')[1];
        parsedParams = parseSearchParams(rawParams);
    };
    let rawipaddr = res.socket.remoteAddress;


    let ipv4addr = processRawIpAddr(rawipaddr);
    console.log(`${rawipaddr}, ${ipv4addr}`);
    let isMasterToken = true;
    if (parsedParams.token !== GLOBAL_CONFIG.TokenMaster) {
        isMasterToken = false;
        if (RT_RateLimitTable[rawipaddr] >= GLOBAL_CONFIG.MaxRateMinute) {
            res.writeHead(503, {
                'Content-Type': 'text/plain'
            });
            console.log(`[ERROR 1503]: Request too frequent. (${rawipaddr})`);
            res.end(`[ERROR 1503]: Request too frequent`);
            return 0;
        };
    };
    RT_RateLimitTable[rawipaddr] = RT_RateLimitTable[rawipaddr] === undefined ? 1 : RT_RateLimitTable[rawipaddr] + 1;
    // Decide response format
    res.writeHead(200, {
        'Content-Type': 'text/plain'
    });
    let resText = '';
    let resFormat = 'json';
    if (['json','plain4','plain6'].indexOf(parsedParams.fmt) !== -1) {
        resFormat = parsedParams.fmt;
    } else {
        resFormat = 'json';
    };
    const resFunctions = {
        'json': function () {
            return JSON.stringify({
                'date': Date.now(),
                'ipv6': rawipaddr,
                'ipv4': ipv4addr,
                'remainingMinuteQuota': isMasterToken ? 999999 : GLOBAL_CONFIG.MaxRateMinute - RT_RateLimitTable[rawipaddr]
            }, '\t', 4);
        },
        'plain4': function () {
            return ipv4addr
        },
        'plain6': function () {
            return rawipaddr
        }
    };
    resText = resFunctions[resFormat]();
    res.end(resText);
}).listen(ARG_PORT || 7766);

console.log(`IPEchoServer is running on port ${ARG_PORT}`);
