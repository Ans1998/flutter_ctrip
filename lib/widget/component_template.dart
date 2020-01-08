import 'package:flutter/material.dart';

// import 'package:flutter_trip/model/grid_nav_model.dart';
import './../model/grid_nav_model.dart';

class ComponentTemplate extends StatelessWidget{
  final GridNavModel gridNavModel;
  final String name;

  const ComponentTemplate({Key key,@required this.gridNavModel,this.name='xiaoming'}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(name);
  }

//  @override
//  _GridNavState createState() => _GridNavState();

}
//class _GridNavState extends State<GridNav>{
//  @override
//  Widget build(BuildContext context) {
//    return Text(widget.name);
//  }
//}