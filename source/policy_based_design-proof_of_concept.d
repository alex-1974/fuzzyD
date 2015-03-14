/**
* Policy based design
*
* Designing extensible, modular classes
* See: <a href="https://molecularmusings.wordpress.com/2011/06/29/designing-extensible-modular-classes/">designing-extensible-modular-classes</a>
*
* Author:
*   Alexander Leisser <alexander@leisser.org>
* Date:
*   12.02.2015
* Version:
*   1.0alpha
**/
module proof_of_concept.pbdlogger;

import std.stdio;

/**
* Logger Klasse
*
* Basisklasse für den Logger, welche dann um die Policies
* erweitert wird.
*
**/
class Logger(FormatPolicy, OutputPolicy)
{
public:
  void Log(string message)
  {
    m_formatter.Format(buffer, message);
    assert (buffer.length > 0, "Buffer ist leer!");
    m_writer.Write(buffer);
  }
  string buffer;

private:
  FormatPolicy m_formatter;
  OutputPolicy m_writer;
};

/**
* Simple Format
*
* Definiert Funktion Format:
**/
struct simpleFormat {
  void Format(ref string buffer, in string message) {
    buffer = "simple format: " ~ message;
    assert (buffer.length > 0, "Buffer ist leer!");
  }
};

struct extensiveFormat {
  void Format(ref string buffer, in string message) {
    buffer = "extensive format: " ~ message;
    assert (buffer.length > 0, "Buffer ist leer!");
  }
};

struct write2stdout {
  void Write(ref string buffer) {
    assert (buffer.length, "Buffer ist leer!");
    buffer ~= " write2stdout";
    writeln (buffer);
  }
};

struct write2file {
  void Write(ref string buffer) {
    assert (buffer.length, "Buffer ist leer!");
    buffer ~= " write2file";
    writeln (buffer);
  }
};


