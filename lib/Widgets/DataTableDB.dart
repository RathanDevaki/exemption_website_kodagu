import 'dart:developer';

import 'package:flutter/material.dart';
import 'District.dart';
import 'Services.dart';
import 'package:flutter/foundation.dart';

class DataTableDB extends StatefulWidget {
  DataTableDB() : super();
  final String title = 'Data from Mysql';
  @override
  DataTableDBState createState() => DataTableDBState();
}

class DataTableDBState extends State<DataTableDB> {
  District districtShow;
  List<District> _district;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _distIdCOntroller;
  TextEditingController _distNameController;
  District _selectedDistrict;
  bool _isUpdating;
  String _titleProgres;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _district = [];
    _isUpdating = false;
    _titleProgres = widget.title;
    _scaffoldKey = GlobalKey();
    _distIdCOntroller = TextEditingController();
    _distNameController = TextEditingController();
    _getDistrict();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgres = message;
    });
  }

  _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added Succesfully'),
      ),
    );
    //currentState.showSnackBar(SnackBar(content: Text(message),),);
  }

  _createTable() {
    _showProgress('Creating table');
    Services.createTable().then((result) {
      if ('success' == result) {
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  _clearValues() {
    _distIdCOntroller.text = "";
    _distNameController.text = "";
  }

  _addDistrict() {
    if (_distIdCOntroller.text.isEmpty || _distNameController.text.isEmpty) {
      print('Empty Field');
    } else {
      _showProgress('Adding District');
      Services.addDistrict(_distIdCOntroller.text, _distNameController.text)
          .then((result) {
        debugPrint('Debug report: $result');

        log('HTTP result: $result');
        if ('Success' == result) {
          _getDistrict();
          _showSnackBar(context, result);
        }
        _clearValues();
      });
    }
  }

  _getDistrict() {
    _showProgress("Loading Dstrict names");
    Services.getDistrict().then((district) {
      setState(() {
        _district = district;
      });
      _showProgress(widget.title);
    });
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Dist ID'),
            ),
            DataColumn(
              label: Text('Dist Name'),
            )
          ],
          rows: _district
              .map(
                (districtShow) => DataRow(cells: [
                  DataCell(
                    Text(districtShow.distId),
                  ),
                  DataCell(
                    Text(districtShow.distName),
                  )
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgres),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _createTable();
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _getDistrict();
              })
        ],
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _distIdCOntroller,
              decoration: InputDecoration.collapsed(hintText: 'District ID'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _distNameController,
              decoration: InputDecoration.collapsed(hintText: 'District Name'),
            ),
          ),

//here to add update n cancel button _isUpdateing = true
          Expanded(child: _dataBody()),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addDistrict();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
