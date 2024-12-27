const jsonParser = require(__dirname + "/json.js");

describe("JSON Parser Test", function() {
  
  it("can parse a string", async function() {
    const resultado1 = jsonParser.parse('"hola"');
    console.log(resultado1);
  });
  
  it("can parse an object", async function() {
    const resultado1 = jsonParser.parse('{"mensaje":"hola"}');
    console.log(resultado1);
  });

});