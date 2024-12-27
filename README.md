# jsontyped

To support types in JSON.

## Installation

```sh
npm i -s @allnulled/jsontyped
```

## Importation

In node.js:

```js
require("@allnulled/jsontyped");
```

In html:

```html
<script src="node_modules/@allnulled/jsontyped/jsontyped.js"></script>
```

## Usage

```js
JsonTyped.parse(`"This could be a normal JSON"`);
JsonTyped.parse(`@message "This is another level of JSON"`);
JsonTyped.parse(`@deeper.types "This is a valid way of chaining ref types"`);
JsonTyped.parse(`@deeper/types/somewhere/else.js "This is also a valid way of chaining ref types"`);
JsonTyped.parse(`@file:///you/can/specify/protocol/too "This is also a valid way of chaining ref types"`);
JsonTyped.parse(`@http:///you/can/specify/protocol/too "This is also a valid way of chaining ref types"`);
```

Basically, any type supports this "prefix" in which you specify, with these symbols and normal variable-accepted js symbols [A-Za-z_$] +[0-9].

Then it always translate the types to:

```json
{
  $type: "message",
  value: "This is another level of JSON"
}
```

Which is also quite readable. You can customize the output re-building the parser, by `npm run build`.
