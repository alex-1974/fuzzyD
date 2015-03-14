module proof_of_concept.mixinlogger;

import std.stdio;
/**
* Mixin Template Design
*
* Designing extensible, modular classes with mixins
* (see: https://molecularmusings.wordpress.com/2011/06/29/designing-extensible-modular-classes/ )
**/

class BaseLogger
{
public:
  void Log(string text)
  {
    message = text;
    Format();
    assert (buffer, "Buffer ist leer!");
    Write();
  }
protected:
  void Format () {};
  void Write () {};
  string message;
  string buffer;
};

mixin template msimpleFormat () {
  override void Format() {
    this.buffer = "simple format: " ~ message;
    assert (buffer.length > 0, "Buffer ist leer!");
  }
};

mixin template mextensiveFormat () {
  override void Format() {
    this.buffer = "extensive format: " ~ this.message;
    assert (this.buffer.length > 0, "Buffer ist leer!");
  }
};

mixin template mwrite2stdout () {
  override void Write() {
    assert (this.buffer.length, "Buffer ist leer!");
    this.buffer ~= " write2stdout";
    writeln (this.buffer);
  }
};

mixin template mwrite2file () {
  override void Write() {
    assert (this.buffer.length, "Buffer ist leer!");
    this.buffer ~= " write2file";
    writeln (this.buffer);
  }
  string logfile;
  void set_logfile (string file) { this.logfile = file; }
};

class simple2stdout : BaseLogger {
  mixin msimpleFormat;
  mixin mwrite2stdout;
};

class simple2file : BaseLogger {
  mixin msimpleFormat;
  mixin mwrite2file;
};


