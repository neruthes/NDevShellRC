const fs = require('fs');

var mydir = process.argv[2];
var llfile = fs.readFileSync('/home/neruthes/TMP/select-random-file-in-dir__ll.txt').toString();
var files = llfile.split('\n').slice(1).map(function (line) {
    return line.slice(49).replace(/\*$/, '');
}).filter(function (line) {
    return line.split('').reverse()[0] !== '/';
}).join('\n').trim().split('\n');

//console.log(files);

var r = Math.floor(Math.random() * files.length);
console.log(files[r]);
