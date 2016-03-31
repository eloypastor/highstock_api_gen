import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

String baseURL = "http://api.highcharts.com/option/highstock/child/";
String baseMethodsURL = "http://api.highcharts.com/object/highstock-obj/child/";

main(List<String> args) async {
  List<String> topLevelClasses = ["chart", "credits", "exporting", "labels", "legend",
                                  "loading", "navigation", "navigator", "plotOptions", "rangeSelector",
                                  "scrollbar", "series",
                                  "series<area>", "series<arearange>", "series<areaspline>",
                                  "series<areasplinerange>",
                                  "series<column>", "series<columnrange>",
                                  "series<flags>","series<line>","series<ohlc>","series<polygon>",
                                  "series<scatter>","series<spline>",
                                  "subtitle", "title", "tooltip", "xAxis", "yAxis"];

  StringBuffer api = new StringBuffer();

  api.writeln("library highstock.options;");
  api.writeln("");
  api.writeln("import 'package:uuid/uuid.dart';");
  api.writeln("import 'dart:js';");
  api.writeln("import 'package:js/js.dart';");
  api.writeln("import 'dart:html';");
  api.writeln("");
/*
  @JS("Date.UTC")
external DateTime dateUTC (year, month, day);
   */
  api.writeln("@JS('Date.UTC')");
  api.writeln("external DateTime dateUTC (year, month, day);");
  api.writeln("");
  api.writeln("@JS('Highcharts.Chart')");
  api.writeln("class HighchartsChart extends Chart {");
  api.writeln("  external HighchartsChart (ChartOptions options);");
  api.writeln("  external List<Series> get series;");
  api.writeln("  external List<Axis> get axes;");
  api.writeln("}");
  api.writeln("");
  api.writeln("@JS()");
  api.writeln("@anonymous");
  api.writeln("class OptionsObject {");
  api.writeln("  static Uuid uidGen = new Uuid();");
  api.writeln("  JsObject jsChart;");
  api.writeln("}");
  api.writeln("");
  api.writeln("@JS()");
  api.writeln("@anonymous");
  api.writeln("class Axis extends OptionsObject {");
  api.writeln("}");
  api.writeln("");
  api.writeln("@JS()");
  api.writeln("@anonymous");
  api.writeln("class ChartOptions extends OptionsObject {");
  api.writeln("  external factory ChartOptions ();");
  api.writeln("  ");
  api.writeln("  external Chart get chart;");
  api.writeln("  external void set chart (Chart a_chart);");
  api.writeln("  ");
  api.writeln("  external List<String> get colors;");
  api.writeln("  external void set colors (List<String> a_colors);");
  api.writeln("  ");
  api.writeln("  external Credits get credits;");
  api.writeln("  external void set credits (Credits a_credits);");
  api.writeln("  ");
  api.writeln("  external Exporting get exporting;");
  api.writeln("  external void set exporting (Exporting a_exporting);");
  api.writeln("  ");
  api.writeln("  external Labels get labels;");
  api.writeln("  external void set labels (Labels a_labels);");
  api.writeln("  ");
  api.writeln("  external Legend get legend;");
  api.writeln("  external void set legend (Legend a_legend);");
  api.writeln("  ");
  api.writeln("  external Loading get loading;");
  api.writeln("  external void set loading (Loading a_loading);");
  api.writeln("  ");
  api.writeln("  external Navigation get navigation;");
  api.writeln("  external void set navigation (Navigation a_navigation);");
  api.writeln("  ");
  api.writeln("  external PlotOptions get plotOptions;");
  api.writeln("  external void set plotOptions (PlotOptions a_plotOptions);");
  api.writeln("  ");
  api.writeln("  external RangeSelector get rangeSelector;");
  api.writeln("  external void set rangeSelector (RangeSelector a_rangeSelector);");
  api.writeln("  ");
  api.writeln("  external Scrollbar get scrollbar;");
  api.writeln("  external void set scrollbar (Scrollbar a_scrollbar);");
  api.writeln("  ");
  api.writeln("  external List<Series> get series;");
  api.writeln("  external void set series (List<Series> a_series);");
  api.writeln("  ");
  api.writeln("  external Subtitle get subtitle;");
  api.writeln("  external void set subtitle (Subtitle a_subtitle);");
  api.writeln("  ");
  api.writeln("  external Title get title;");
  api.writeln("  external void set title (Title a_title);");
  api.writeln("  ");
  api.writeln("  external Tooltip get tooltip;");
  api.writeln("  external void set tooltip (Tooltip a_tooltip);");
  api.writeln("  ");
  api.writeln("  external XAxis get xAxis;");
  api.writeln("  external void set xAxis (XAxis a_xAxis);");
  api.writeln("  ");
  api.writeln("  external YAxis get yAxis;");
  api.writeln("  external void set yAxis (YAxis a_yAxis);");
  api.writeln("  ");
  api.writeln("}");
  api.writeln("");

  await Future.forEach(topLevelClasses, (String topLevelClass) async {
    api.write(await generateApi(topLevelClass));
  });

  print(api.toString());
}

String getMethodReturnType (String jsReturnType, String propertyName, bool isParent) {
  String type = getType(jsReturnType, propertyName, isParent);
  if (type == "JsObject") {
    type = "dynamic";
  }
  return type;
}

String getType (String jsReturnType, String propertyName, bool isParent) {
  String out = "dynamic";
  if (jsReturnType == null && isParent) {
    out = startUpperCase(dashesToCamelCase(propertyName));
  }
  else {
    switch (jsReturnType) {
      case "Boolean":
        out = "bool";
        break;
      case "String":
        out = "String";
        break;
      case "Number":
        out = "num";
        break;
      case "Color":
        out = "dynamic";  // A color can be a String or an object (see: http://www.highcharts.com/docs/chart-design-and-style/colors)
        break;
      case "Function":
        out = "Function";
        break;
      case "Array<Boolean>":
        out = "List<bool>";
        break;
      case "Array<String>":
        out = "List<String>";
        break;
      case "Array<Number>":
        out = "List<num>";
        break;
      case "Array<Object>":
        out = "List<JsObject>";
        break;
      case "Array<Color>":
        out = "List<String>";
        break;
      case "Array":
        out = "List";
        break;
      case "Object":
        out = "JsObject";
        break;
    }
  }
  return out;
}

String startUpperCase (String text) {
  return text[0].toUpperCase() + text.substring(1);
}

String processSeriesClass (String clazz) {
  RegExp seriesClassRegex = new RegExp (r"series<(.*)>");
  Iterable<Match> matches = seriesClassRegex.allMatches(clazz);
  var formattedClass = clazz;
  if (matches.length > 0) {
    formattedClass = startUpperCase(matches.elementAt(0).group(1)) + "Series";
  }
  return formattedClass;
}

String dashesToCamelCase (String dashes) {
  var splitted = dashes.split("-");
  var out = "";
  splitted.forEach((String dash) {
    var formattedDash = processSeriesClass(dash);
    out = out + startUpperCase(formattedDash);
  });
  return out;
}

bool isSeriesClass (String className) {
  RegExp regex = new RegExp(r".+Series$");
  return regex.allMatches(className).length > 0;
}

bool isAxisClass (String className) {
  return className.toLowerCase == "xaxis" || className.toLowerCase() == "yaxis";
}

Future<String> generateApi (String child) async {
  List apiJson = await getApiJson(child);
  List apiMethodsJson = await getApiMethodsJson (child);
  List<String> parents = [];
  StringBuffer sb = new StringBuffer();

  if (apiJson != null) {
    sb.writeln("@JS()");
    sb.writeln("@anonymous");

    String className = dashesToCamelCase(child);

    if (isAxisClass(className)) {
      sb.writeln("class $className extends Axis {");
    }
    else if (isSeriesClass(className)) {
      sb.writeln("class $className extends Series {");
    }
    else if (className == "Series") {
      sb.writeln("class $className extends PlotOptions {");
    }
    else {
      sb.writeln("class $className extends OptionsObject {");
    }
    sb.writeln("  external factory $className ();");

    List<String> propNames = [];

    apiJson.forEach((Map propertyApi) {
      String propName = propertyApi['fullname'].split(
          "\.")[propertyApi['fullname']
          .split("\.")
          .length - 1];
      String type = getType(propertyApi['returnType'], propertyApi['name'], propertyApi['isParent']);
      if (propName != "") {
        sb.writeln("  /** \n   * ${propertyApi['description']} \n   */");
        if (propertyApi['deprecated'] != null && propertyApi['deprecated'])
          sb.writeln("  @deprecated");
        sb.writeln("  external $type get $propName;");
        if (propertyApi['deprecated'] != null && propertyApi['deprecated'])
          sb.writeln("  @deprecated");
        sb.writeln("  external void set $propName ($type a_$propName);");
        if (propertyApi['isParent']) {
          parents.add(propertyApi['name']);
        }
        propNames.add(propName);
      }
    });

    // Now lets start with the methods:
    apiMethodsJson.forEach((Map methodApi) {
      if (methodApi['type']=="method") {
        List<String> methodNameSplitted = methodApi['fullname'].split(r".");
        String methodName = methodNameSplitted[methodNameSplitted.length - 1];
        var alreadyInProperties = propNames.contains(methodName);
        if (!alreadyInProperties) {
          List<String> paramsSplitted = [];
          if (methodApi['params'] != null) {
            paramsSplitted = (methodApi['params'] as String)
                .replaceAll(r"(", "")
                .replaceAll(r")", "")
                .replaceAll(r"[", "")
                .replaceAll(r"]", "")
                .split(",");
          }
          String convertedParams = "";
          bool first = true;
          paramsSplitted.forEach((String param) {
            List<String> splitted = param.trim().split(" ");
            if (splitted != null && splitted.length == 2) {
              String type = splitted[0];
              String name = splitted[1].replaceAll(r"|", "_or_");
              String convertedType = getMethodReturnType(type, "", false);
              convertedParams = convertedParams +
                  "${first ? '' : ','} ${convertedType} ${name}";
              first = false;
            }
            else {
              print(
                  "Warning: param \"$param\" has not been processed when parsing methods for $child");
            }
          });
          String convertedReturnType = methodApi['returnType'] == null ||
              methodApi['returnType'] == '' ? "void" : getMethodReturnType(
              methodApi['returnType'], "", false);
          sb.writeln("  /** ");
          sb.writeln("  * ${methodApi['paramsDescription']}");
          sb.writeln("  */");
          sb.writeln(

              "  external $convertedReturnType $methodName ($convertedParams);");
        }
      }
    });

    sb.writeln("}");

    await Future.forEach(parents, (String property) async {
      sb.write(await generateApi(property));
    });
  }

  return sb.toString();
}

Future<List> getApiJson (String child) async {
  var url = "$baseURL$child";
  var response = await http.get(url);
  List out = null;
  try {
    out = JSON.decode(response.body);
  }
  catch (e) {
    print ("Error processing $child");
  }
  return out;
}

Future<List> getApiMethodsJson (String child) async {
  var url = "$baseMethodsURL${startUpperCase(child)}";
  var response = await http.get(url);
  List out = null;
  try {
    out = JSON.decode(response.body);
  }
  catch (e) {
    print ("Error processing methods for $child");
  }
  return out;
}