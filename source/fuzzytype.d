/** Implementation of a fuzzy type

Classical logic only permits conclusions which are either true or false.
Fuzzy logic is a form of logic in which the truth values of variables may be any real number between 0 and 1 inclusive.

Fuzzy_logic_operators:

    <p><b>NOT</b> (<math><mo>-</mo><mi>A</mi></math>)
    <ul>
      <li><math><mn>1</mn><mo>-</mo><mi>A</mi></math></li>
    </ul></p>
    <p><b>AND</b> (<math><mi>A</mi><mo>&</mo><mi>B</mi></math>)
    <ul>
      <li><math><mi>A</mi><mo>if</mo><mi>A</mi><mo><</mo><mi>B</mi></math></li>
      <li><math><mi>B</mi><mo>if</mo><mi>A</mi><mo>>=</mo><mi>B</mi></math></li>
    </ul></p>
    <p><b>OR</b> (<math><mi>A</mi><mo>|</mo><mi>B</mi></math>)
    <ul>
      <li><math><mi>A</mi><mo>if</mo><mi>A</mi><mo>></mo><mi>B</mi></math></li>
      <li><math><mi>B</mi><mo>if</mo><mi>A</mi><mo><=</mo><mi>B</mi></math></li>
    </ul></p>
    <p><b>XOR</b> (<math><mi>A</mi><mo>^</mo><mi>B</mi></math>)
    <ul>
      <li><math><mi>A</mi><mo>if</mo><mi>A</mi><mo>></mo><mi>B</mi><mo>and</mo><mi>A</mi><mo><</mo><mo>(</mo><mi>1</mi><mo>-</mo><mi>B</mi><mo>)</mo></math></li>
      <li><math><mn>1</mn><mo>-</mo><mi>B</mi><mo>if</mo><mi>A</mi><mo>></mo><mi>B</mi><mo>and</mo><mi>A</mi><mo>>=</mo><mo>(</mo><mi>1</mi><mo>-</mo><mi>B</mi><mo>)</mo></math></li>
      <li><math><mi>B</mi><mo>if</mo><mi>B</mi><mo>>=</mo><mi>A</mi><mo>and</mo><mi>B</mi><mo><</mo><mo>(</mo><mi>1</mi><mo>-</mo><mi>A</mi><mo>)</mo></math></li>
      <li><math><mn>1</mn><mo>-</mo><mi>A</mi><mo>if</mo><mi>B</mi><mo>>=</mo><mi>A</mi><mo>and</mo><mi>B</mi><mo>>=</mo><mo>(</mo><mi>1</mi><mo>-</mo><mi>A</mi><mo>)</mo></math></li>
    </ul></p>
**/
module fuzzy.type;

import std.traits;
debug import std.stdio;

/** Struct representing the fuzzy type
**/
struct Fuzzy {
    double _value = 0.0;
    /** **/
    this (double value) pure @safe { this.value(value); }
    @property void value (double prob) pure @safe {
        import std.exception: enforce;
        enforce(0.0 <= _value && _value <= 1.0, "Fuzzy is out of range!");
        this._value = prob;
    }
    @property auto value () const pure nothrow @safe @nogc { return this._value; }
    alias value this;
    /** logical AND **/
	Fuzzy opBinary(string op)(in Fuzzy var) const pure @safe if (op == "&") {
		return (this.value < var.value)? Fuzzy(this.value) : Fuzzy(var.value);
	}
	/** ditto **/
    // for type bool
	Fuzzy opBinary(string op)(in bool var) const pure @safe if (op == "&") {
		return (var)? Fuzzy(this.value) : Fuzzy(0.0);
	}
	/** logical OR **/
	Fuzzy opBinary(string op)(in Fuzzy var) const pure @safe if (op == "|") {
		return (this.value > var.value)? Fuzzy(this.value) : Fuzzy(var.value);
	}
	/** ditto **/
    // for type bool
	Fuzzy opBinary(string op)(in bool var) const pure @safe if (op == "|") {
		return (var)? Fuzzy(1.0) : Fuzzy(this.value);
	}
    /** logical XOR **/
    Fuzzy opBinary(string op)(in Fuzzy var) const pure @safe if (op == "^") {
        if (this.value > var) {
            return this.value < 1-var? Fuzzy(this.value):Fuzzy(1-var);
        }
        else return var < -this? Fuzzy(var):Fuzzy(-this);
    }
    /** ditto **/
    // for type bool
    Fuzzy opBinary(string op)(in bool var) const pure @safe if (op == "^") {
        return var? (this^fuzzy(1.0)):(this^fuzzy(0.0));
    }
	/** negation **/
	Fuzzy opUnary(string op)() const pure @safe if (op == "-") {
		return Fuzzy(1.0-this.value);
	}
}

/** **/
auto fuzzy (T) (T value) if (isNumeric!T || isBoolean!T) {
    static if (isBoolean!T) {
        return value == true? Fuzzy(1.0):Fuzzy(0.0);
    }
    else if (isNumeric!T) {
        import std.conv: to;
        return Fuzzy(value.to!double);
    }
    else assert(0);
}
unittest {
    Fuzzy f;
    f = 0.5;
    assert(f == 0.5);
    auto i = fuzzy(1);
    assert(i == 1.0);
    auto b = fuzzy(true);
    assert(b == 1.0);
}
unittest {
    auto a = fuzzy(0.25);
    auto b = fuzzy(0.5);
    // and
    assert((a&b) == 0.25);
    assert((a&true) == 0.25);
    // or
    assert((a|b) == 0.5);
    assert((a|true) == 1.0);
    // xor
    assert( (fuzzy(0.6)^fuzzy(0.3)) == 0.6);
    assert( (fuzzy(0.55)^fuzzy(0.5)) == 0.5);
    assert( (fuzzy(0.3)^fuzzy(0.6)) == 0.6);
    assert( (fuzzy(0.5)^fuzzy(0.55)) == 0.5);
    assert( (fuzzy(0.25)^true) == 0.75);
    // not
    assert(-a == 0.75);
    // ufcs
    assert((a&b&false) == 0.0);
}
