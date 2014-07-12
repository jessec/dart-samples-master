
import 'dart:html';
import "package:menu/menu.dart";

class Basics {
  Element _dragSourceEl;
  Element columns = document.querySelector('#columns');
  
  void start() {
    
    var menuItems = document.querySelector('menu').children;
    for(var item in menuItems){
      item.onClick.listen(_onClickMenuItem);
    }

    var cols = document.querySelectorAll('#columns .column');
    for (var col in cols) {
      col.onDragStart.listen(_onDragStart);
      col.onDragEnd.listen(_onDragEnd);
      col.onDragEnter.listen(_onDragEnter);
      col.onDragOver.listen(_onDragOver);
      col.onDragLeave.listen(_onDragLeave);
      col.onDrop.listen(_onDrop);
      col.onClick.listen(_onClickResize);
    }
    
    Widget widget = new WidgetImpl();
    num x = widget.getX();
    print(x);
    
  }

  void _onClickMenuItem(MouseEvent event) {
    Element menuTarget = event.target;
    switch (menuTarget.innerHtml) {
      case '320':
        _resizeScreen('320');
        break;
      case '640':
        _resizeScreen('640');
        break;
      case '768':
        _resizeScreen('768');
        break;
      case '960':
        _resizeScreen('960');
        break;
      case '1280':
        _resizeScreen('1280');
        break;
      case 'load':
        _load();
        break;
      case 'save':
        _save();
        break;
    }
    
  }
  
  void _load(){
    print('load');  
  }
  
  void _save(){
    print('save');
  }
  
  void _resizeScreen(String strSize){
    int intSize = int.parse(strSize);
    columns.style.setProperty('width', '${strSize}px');
    columns.style.setProperty('margin-left', '-${intSize / 2}px');
  }

  void _onClickResize(MouseEvent event) {
    Element resizeTarget = event.target;
    String name = resizeTarget.className;
    if(name != "content"){
      print("content");
      resizeTarget.style.setProperty('overflow', 'auto');
    }else{
      resizeTarget.parent.style.setProperty('overflow', 'auto');
    }
    
  }

  void _onDragStart(MouseEvent event) {
    Element dragTarget = event.target;
    dragTarget.style.setProperty('overflow', 'visible');
    dragTarget.classes.add('moving');
    _dragSourceEl = dragTarget;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/html', dragTarget.innerHtml);
  }

  void _onDragEnd(MouseEvent event) {
    Element dragTarget = event.target;
    dragTarget.classes.remove('moving');
    var cols = document.querySelectorAll('#columns .column');
    for (var col in cols) {
      col.classes.remove('over');
    }
  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.add('over');
  }

  void _onDragOver(MouseEvent event) {
    // This is necessary to allow us to drop.
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.remove('over');
  }

  void _onDrop(MouseEvent event) {
    // Stop the browser from redirecting.
    event.stopPropagation();

    // Don't do anything if dropping onto the same column we're dragging.
    Element dropTarget = event.target;
    if (_dragSourceEl != dropTarget) {
      // Set the source column's HTML to the HTML of the column we dropped on.
      _dragSourceEl.style.setProperty('overflow', 'visible');
      _dragSourceEl.setInnerHtml(dropTarget.innerHtml, treeSanitizer: new NullTreeSanitizer());
      dropTarget.setInnerHtml(event.dataTransfer.getData('text/html'), treeSanitizer: new NullTreeSanitizer());
    }
  }
}

void main() {
  var basics = new Basics();
  basics.start();
}

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(Node node) {}
}
