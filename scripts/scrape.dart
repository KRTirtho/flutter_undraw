/// Scrapping undraw.co because they went bad bad and stopped providing
/// the free API access. Never turn your back on the open-source community.
library;

import 'dart:convert';
import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:slugify/slugify.dart';
import 'package:num_to_words/num_to_words.dart';

const baseUrl = 'https://undraw.co/illustrations';

const keywords = [
  "assert",
  "break",
  "case",
  "catch",
  "class",
  "const",
  "continue",
  "default",
  "do",
  "else",
  "enum",
  "extends",
  "false",
  "final",
  "finally",
  "for",
  "if",
  "in",
  "is",
  "new",
  "null",
  "rethrow",
  "return",
  "super",
  "switch",
  "this",
  "throw",
  "true",
  "try",
  "var",
  "void",
  "while",
  "with",
  "async",
  "hide",
  "on",
  "show",
  "sync",
  "abstract",
  "as",
  "covariant",
  "deferred",
  "dynamic",
  "export",
  "extension",
  "external",
  "factory",
  "function",
  "get",
  "implements",
  "import",
  "interface",
  "library",
  "mixin",
  "operator",
  "part",
  "set",
  "static",
  "typedef",
  "await",
  "yield",
];

void main(List<String> args) async {
  final http = Client();

  final rootPage = await http.get(Uri.parse(baseUrl)).then((response) {
    return parse(response.body);
  });

  final pagination = rootPage
      .querySelector(
        "#__next > div.flex.items-center.justify-center.gap-2.mb-12 > span",
      )
      ?.text;

  if (pagination == null) {
    throw Exception("The selector for pagination has been changed");
  }

  final totalPages = int.parse(pagination.split(" ").last);

  stdout.writeln("🔵 Total pages: $totalPages");

  final allPages = <Map<String, dynamic>>[
    jsonDecode(rootPage.getElementById("__NEXT_DATA__")!.text),
  ];

  for (var i = 2; i <= totalPages; i++) {
    stdout.writeln("🟡 Scraping page $i/$totalPages");
    final page = await http.get(Uri.parse("$baseUrl/$i")).then((response) {
      return parse(response.body);
    });

    allPages.add(jsonDecode(page.getElementById("__NEXT_DATA__")!.text));
  }

  stdout.writeln("🟢 Scraped illustrations");

  final illustrations = allPages
      .map((page) => page["props"]["pageProps"]["illustrations"])
      .expand((element) => element)
      .toList();

  final generatedLines = [
    "/// Generated file. Do not edit.",
    "/// Run `dart scripts/scrape.dart` to update",
    "enum UndrawIllustration {",
  ];

  final names = <String>[];

  for (final illustration in illustrations) {
    String name = slugify(illustration["title"], delimiter: "_");
    // To avoid Dart keywords
    if (keywords.contains(name)) {
      name = "${name}Svg";
    }
    // To avoid duplicates
    if (names.contains(name)) {
      name = slugify("${illustration["newSlug"]}", delimiter: "_");
    }
    // To avoid starting with a number
    if (RegExp(r'\d').hasMatch(name[0])) {
      name = slugify("${int.parse(name[0]).toWords()}${name.substring(1)}");
    } else if (!RegExp(r'\w').hasMatch(name[0])) {
      name = name.substring(1);
    }

    names.add(name);

    final file = File("lib/assets/undraw/$name.svg");

    if (!await file.exists()) {
      stdout.writeln("🟡 Downloading svg $name");

      final svg = await http
          .get(Uri.parse(illustration["media"]))
          .then((response) => response.body);
      await file.writeAsString(svg);
    }

    generatedLines.add(
      "/// `$name`: ${illustration["title"]}\n"
      "///\n"
      "/// asset path: `packages/flutter_undraw/${file.path.replaceAll("lib/", "")}`\n"
      "///\n"
      "/// <img src='${illustration["media"]}' alt='$name' width='200'/>\n"
      "${name.toCamelCase()}('${file.path.replaceAll("lib/", "")}')${illustrations.last == illustration ? ';' : ','}",
    );
  }

  stdout.writeln("🟢 Downloaded all illustrations");

  generatedLines.addAll([
    "final String path;",
    "const UndrawIllustration(this.path);",
    "}",
  ]);

  final generatedFile = await File(
    "lib/src/collection/undraw_illustration.dart",
  ).writeAsString(generatedLines.join("\n"));

  await Process.run("dart", ["format", generatedFile.path]);

  stdout.writeln("🟢 Generated file ${generatedFile.path}");
}
