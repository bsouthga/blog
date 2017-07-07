/**
 * much of this is copied from https://github.com/evancz/elm-markdown
 */
var _bsouthga$blog$Native_KaTeX = function() {


// VIRTUAL-DOM WIDGET IMPLEMENTATION

var implementation = {
  render: _render,
  diff: diff
};


// VIRTUAL-DOM WIDGETS

function renderElement(options, expression) {
  options.throwOnError = false;

  var model = {
    options: options,
    expression: expression
  };

  var factList = {ctor: '[]'};

  return _elm_lang$virtual_dom$Native_VirtualDom
    .custom(factList, model, implementation);
}


function tryRenderKatex(expression, element, options) {
  try {
    katex.render(expression, element, options);
    return element;
  } catch (err) {
    return element;
  }
}


function _render(model) {
  var div = document.createElement('div');

  return tryRenderKatex(model.expression, div, model.options);
}


function diff(a, b) {
  if (a.model.expression === b.model.expression &&
    a.model.options === b.model.options) {
    return null;
  }

  return {
    applyPatch: applyPatch,
    data: b.model
  };
}


function applyPatch(domNode, data) {
  var options = data.options;
  var expression = data.expression;

  options.throwOnError = false;

  return tryRenderKatex(
    expression,
    domNode,
    options
  );
}

function renderToString(options, expression) {
  options.throwOnError = false;
  try {
    return katex.renderToString(expression, options);
  } catch (err) {
    return '';
  }
}

return {
  render: F2(renderElement),
  renderToString: F2(renderToString)
};

}();