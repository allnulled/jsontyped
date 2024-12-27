const fs = require("fs");

const base = fs.readFileSync(__dirname + "/jsontyped.js").toString();

let output = base.replace(`module.exports = {
  SyntaxError: peg$SyntaxError,
  parse:       peg$parse
};`, `return {
  SyntaxError: peg$SyntaxError,
  parse:       peg$parse
};`);

const header = `(function(factory) {
  const mod = factory();
  if(typeof window !== 'undefined') {
    window["JsonTyped"] = mod;
  }
  if(typeof global !== 'undefined') {
    global["JsonTyped"] = mod;
  }
  if(typeof module !== 'undefined') {
    module.exports = mod;
  }
})(function() {\n`;

const footer = `\n});`

output = header + output + footer;

fs.writeFileSync(__dirname + "/jsontyped.js", output, "utf8");