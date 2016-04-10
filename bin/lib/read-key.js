/* jshint node: true, esnext: true, strict: true, undef: true */

const FS = require("fs");
const PATH = require("path");

const FILE=PATH.resolve(process.argv[2]);
const KEY=process.argv[3];

const O = JSON.parse(FS.readFileSync(FILE).toString());

if (!O.hasOwnProperty(KEY)) {
  console.error("!!! Key not found: " + KEY + " in " + FILE);
  process.exit(1);
}

console.log(O[KEY]);
