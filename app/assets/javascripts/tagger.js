function Tagger(parent, feedback, x, y, width, height) {

  this.parent = document.getElementById(parent);
  this.feedback = document.getElementById(feedback);
  this.x = document.getElementById(x);
  this.y = document.getElementById(y);
  this.width = document.getElementById(width);
  this.height = document.getElementById(height);

  this.feedback.style.display = 'block';
  this.isMouseDown = false;
  var obj = this;

  this.parent.onmousedown = function(event) {
    obj.mouseDown(event);
  }

  this.parent.onmousemove = function(event) {
    obj.mouseMove(event);
  }

  this.parent.onmouseup = function(event) {
    obj.mouseUp(event);
  }
}


Tagger.prototype.mouseDown = function(event) {
  this.isMouseDown = true;

  this.firstX = event.pageX - this.parent.offsetLeft;
  this.firstY = event.pageY - this.parent.offsetTop;

  this.feedback.style.width = '0px';
  this.feedback.style.height = '0px';

  this.feedback.style.left = this.firstX + 'px';
  this.feedback.style.top = this.firstY + 'px';

  event.preventDefault();
}


Tagger.prototype.mouseUp = function(event) {
  this.isMouseDown = false;

  this.x.value = this.feedback.offsetLeft;
  this.y.value = this.feedback.offsetTop;
  this.width.value = this.feedback.offsetWidth;
  this.height.value = this.feedback.offsetHeight;
}


Tagger.prototype.mouseMove = function(event) {
  if (!this.isMouseDown) return;

  var x = event.pageX - this.parent.offsetLeft;
  var y = event.pageY - this.parent.offsetTop;

  if (this.inRangeX(x)) this.feedback.style.left = x + 'px';
  if (this.inRangeY(y)) this.feedback.style.top =  y + 'px';
  
  // abs ensures the dragging works in any direction
  this.feedback.style.width = Math.abs(x - this.firstX) + 'px';
  this.feedback.style.height = Math.abs(y - this.firstY) + 'px';
}


Tagger.prototype.inRangeX = function(x) {
  return x < this.firstX;
}


Tagger.prototype.inRangeY = function(y) {
  return y < this.firstY;
}
