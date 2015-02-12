/**
* Proof of concepts
*
* Verschiedene Module, die demonstrieren, wie man in D programmieren kann.
*
* Author: Alexander Leisser <alexander@leisser.org>
* Date: 12.02.2015
* Version: 1.0alpha
* History:
*   V1 is initial version
*
* License: free to use
*
* Examples:
* <ol>
*   <li><a href="policy_based_design-proof_of_concept.html">Policy Based Design Logger</a></li>
*   <li><a href="mixin_logger-proof_of_concept.html">Mixin Based Logger</a></li>
* </ol>
**/
module proof_of_concept;

import std.stdio;

public import proof_of_concept.mixinlogger;
public import proof_of_concept.pbdlogger;


/** main function
*
* uses the different modules
**/
void main () {
  /* policy based design logger */
  writeln ("Policy based design Logger");
  alias stdoutlog = Logger!(simpleFormat,write2stdout);
  alias filelog = Logger!(simpleFormat,write2file);
  alias extstdoutlog = Logger!(extensiveFormat,write2stdout);
  auto outlog = new stdoutlog();
  outlog.Log("simple message to stdout");
  auto flog = new filelog();
  flog.Log("simple message to file");
  auto extoutlog = new extstdoutlog();
  extoutlog.Log("extensive message to stdout");
  extoutlog.Log("another extensive message to stdout");

  /* mixin based logger */
  writeln ("Mixin based Logger");
  auto mmyLog = new simple2stdout;
  mmyLog.Log("Message");
  auto mfilelog = new simple2file;
  mfilelog.Log("message");
}
