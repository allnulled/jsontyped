{
  // Función auxiliar para convertir cadenas con escapes
  function unescapeString(str) {
    return JSON.parse(str);
  }
}

Start
  = value:Value { return value; }

Value
  = tp:Type_def? _ vl:Value_untyped { return tp ? { ...tp, $value: vl } : vl; }

// Define una `Type_def` que acepta URLs completas
Type_def = Type_def_by_request / Type_def_by_js_property

Js_noun = [A-Za-z\$_] [A-Za-z0-9\$_]* { return text() }

Js_noun_predotted =
  "." noun:Js_noun
    { return noun }

Js_path = 
  first:Js_noun
  others:Js_noun_predotted*
    { return [first].concat(others || []) }

Type_def_by_js_property
  = "@" jspath:Js_path
    {
      return {
        $protocol: jspath,
      };
    }

Type_def_by_request
  = "@" protocol:Type_protocol "//" "/"? host:Host path:Path? query:Query_string? fragment:Fragment? {
      return {
        $protocol: protocol,
        $host: host,
        $path: path || "/",
        $query: query || null,
        $fragment: fragment || null
      };
    }

Type_protocol
  = protocol:([A-Za-z][A-Za-z0-9+\-.]* ":") {
      return text().slice(0, -1); // Remueve el ":" del final
    }

Host
  = host:([A-Za-z0-9\-._~%]+) {
      return host.join("");
    }

Path
  = path:("/" [A-Za-z0-9\-._~%!$&'()*+,;=:@/]*) {
      return text().substr(1);
    }

Query_string
  = "?" params:Query_param_list {
      return params;
    }

Query_param_list
  = head:Query_param tail:("&" Query_param)* {
      return [head, ...tail.map(item => item[1])];
    }

Query_param
  = key:[A-Za-z0-9\-._~%]+ "=" value:[A-Za-z0-9\-._~%]+ {
      return { key: key.join(""), value: value.join("") };
    }

Fragment
  = "#" id:[A-Za-z0-9\-._~%!$&'()*+,;=:@/]+ {
      return id.join("");
    }

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
