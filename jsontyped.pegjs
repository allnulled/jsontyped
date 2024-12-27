{
  // Función auxiliar para convertir cadenas con escapes
  function unescapeString(str) {
    return JSON.parse(str);
  }
}

Start
  = value:Value { return value; }

Value = tp:Type_def? _ vl:Value_untyped { return tp ? { $type: tp, value: vl } : vl }

// This is for normal JSON:
// Value = Value_untyped

Type_def = "@" Type_protocol? p:Js_path { return p }

Type_protocol = [A-Za-z0-9_\$\-\.]+ "://" { return text()}

Js_path = 
  first:Js_noun_predotted_maybe
  others:Js_noun_predotted*
    { return text() || [first].concat(others || []) }

Js_noun = [A-Za-z_$] [A-Za-z0-9_$]* { return text() }

Js_noun_predotted = ("." / "/") n:Js_noun { return n }

Js_noun_predotted_maybe = ("." / "/")? n:Js_noun { return n }

Value_untyped
  = Object
  / Array
  / String
  / Number
  / Boolean
  / Null

Object
  = "{" _ members:MemberList? _ "}" {
      return members !== null ? members : {};
    }

MemberList
  = head:Member tail:(_ "," _ Member)* {
      const result = { [head.key]: head.value };
      tail.forEach((item) => {
        const subitem = item[3];
        const { key, value } = subitem;
        result[key] = value;
      });
      return result;
    }

Member
  = key:String _ ":" _ value:Value {
      return { key, value };
    }

Array
  = "[" _ elements:ElementList? _ "]" {
      return elements !== null ? elements : [];
    }

ElementList
  = head:Value tail:(_ "," _ Value)* {
      return [head, ...tail.map(e => e[3])];
    }

String
  = '"' chars:DoubleQuotedString '"' {
      return chars;
    }

DoubleQuotedString
  = chars:('\\"' / ((!'"') .))* { return text(); }

Number
  = value:$("-"? [0-9]+ ("." [0-9]+)? ([eE] [-+]? [0-9]+)?) {
      return parseFloat(value);
    }

Boolean
  = "true" { return true; }
  / "false" { return false; }

Null
  = "null" { return null; }

_ "whitespace"
  = [ \t\n\r]*
