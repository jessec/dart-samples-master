import 'dart:html';
import 'dart:convert';
import "package:menu/menu.dart";

class Basics {
  Element _dragSourceEl;
  Element columns = document.querySelector('#columns');
  String apiBaseUrl = 'http://localhost:9090/api/dragster';

  Element menuHostnameJsonDatalist = document.getElementById('menu-hostname-json-datalist');
  Element menuHostname = document.getElementById('menu-hostname');
  Element menuPageJsonDatalist = document.getElementById('menu-page-json-datalist');
  Element menuPageJson = document.getElementById('menu-page');
  Element menuVersionJsonDatalist = document.getElementById('menu-version-json-datalist');
  Element menuVersion = document.getElementById('menu-version');
  Element menuStatusJsonDatalist = document.getElementById('menu-status-json-datalist');
  Element menuStatus = document.getElementById('menu-status');
  Element menuDisplayJsonDatalist = document.getElementById('menu-display-json-datalist');
  Element menuDisplay = document.getElementById('menu-display');

  void start() {

    var menuItems = document.querySelector('#menu').children;
    for (var item in menuItems) {
      item.onClick.listen(_onClickMenuItem);
    }

    _fillMenuInputItems(menuHostnameJsonDatalist, "/dragster/html/data/hostnames.json");
    menuHostname.onChange.listen(_onInputMenuChange);
    _fillMenuInputItems(menuPageJsonDatalist, "/dragster/html/data/hostnames.json");
    _fillMenuInputItems(menuVersionJsonDatalist, "/dragster/html/data/hostnames.json");
    _fillMenuInputItems(menuStatusJsonDatalist, "/dragster/html/data/hostnames.json");
    _fillMenuInputItems(menuDisplayJsonDatalist, "/dragster/html/data/hostnames.json");

    
    

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
  
  void _onInputMenuChange(Event event){
    InputElement inputBox = event.target;
    String value = inputBox.value;
    print(value);
  }

  void _fillMenuInputItems(Element optionList, String jsonSourceUrl) {

    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        List parsedList = JSON.decode(request.responseText);
        for (var value in parsedList) {
          Element option = document.createElement('option');
          option.setAttribute('value', value);
          optionList.append(option);
        }
        
      }
    });

    var data = {
      "id": "QHL2NIOYKGU1",
      "host": {
        "id": "2",
        "name": null
      },
      "name": null,
      "versions": [],
      "currentVersion": {
        "id": "2",

        "name": null
      },
      "status": "available",
      "html": null
    };





    request.open("GET", jsonSourceUrl, async: false);
    request.send(data.toString());


  }

  void _attachDataList(String responseText, Element optionList) {

    List parsedList = JSON.decode(responseText);
    for (var value in parsedList) {
      Element option = document.createElement('option');
      option.setAttribute('value', value);
      optionList.append(option);
    }
  }

  void _onClickMenuItem(MouseEvent event) {
    Element menuTarget = event.target;
    switch (menuTarget.innerHtml.trim().toLowerCase()) {
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

  void _load() {
    print('load');
  }

  void _save() {

    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        print(request.responseText); // output the response from the server
      }
    });

    var data = {
      "id": "QHL2NIOYKGU1",
      "host": {
        "id": "2",
        "name": null
      },
      "name": null,
      "versions": [],
      "currentVersion": {
        "id": "2",

        "name": null
      },
      "status": "available",
      "html": null
    };




    var url = "http://localhost:9090/api/dragster";
    request.open("POST", url, async: false);
    request.send(data.toString());


  }

  void _resizeScreen(String strSize) {
    int intSize = int.parse(strSize);
    columns.style.setProperty('position', 'relative');
    columns.style.setProperty('left', '50%');
    columns.style.setProperty('width', '${strSize}px');
    columns.style.setProperty('margin-left', '-${intSize / 2}px');
  }

  void _onClickResize(MouseEvent event) {
    Element resizeTarget = event.target;
    if (resizeTarget.className != "content") {
      resizeTarget.style.setProperty('overflow', 'auto');
    } else {
      resizeTarget.parent.style.setProperty('overflow', 'auto');
    }

  }

  void _onDragStart(MouseEvent event) {

    var contentItems = document.querySelectorAll('.content');
    for (var content in contentItems) {
      content.classes.add('hide');
    }


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

    var contentItems = document.querySelectorAll('.content');
    for (var content in contentItems) {
      content.classes.remove('hide');
    }


  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.add('over');
  }

  void _onDragOver(MouseEvent event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.remove('over');
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    Element dropTarget = event.target;
    if (_dragSourceEl != dropTarget) {
      _dragSourceEl.style.setProperty('overflow', 'visible');
      Element container = dropTarget.children.first;
      if (container.tagName == 'DIV' && container.className.startsWith('content')) {
        _dragSourceEl.setInnerHtml(dropTarget.innerHtml, treeSanitizer: new NullTreeSanitizer());
        dropTarget.setInnerHtml(event.dataTransfer.getData('text/html'), treeSanitizer: new NullTreeSanitizer());
      }

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
