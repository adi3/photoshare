function Search(box, param, action, results) {
  this.element = document.getElementById(box);
  this.param = param;
  this.action = action;
  this.results = document.getElementById(results);

  var obj = this;

  this.element.onkeyup = function(e) {
    obj.onKeyUp(e);
  }

  if (window.XMLHttpRequest) {
    this.request = new XMLHttpRequest();
    this.request.onreadystatechange = function() {
      obj.onReadyStateChange();
    }
  }
}


Search.prototype.onKeyUp = function(e) {
  var query = encodeURIComponent(this.element.value);
  if (query.length == 0) this.results.innerHTML = "";
  else if (window.XMLHttpRequest) {
    var data = this.action + "?" + this.param + "=" + query;
    this.request.open("GET", data, true);
    this.request.send();
  }
}


Search.prototype.onReadyStateChange = function() {
  if (this.request.readyState == 4 && this.request.status == 200) {
    this.results.innerHTML = this.request.responseText;
  }
}