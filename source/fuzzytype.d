/**
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

/**
Fuzzy Typ erlaubt Wahrheitswerte von 0 bis 1.
Erweitert den Typ bool, um Werte zwischen 0 (false) und 1 (wahr) darzustellen.
Die Genauigkeit der möglichen Werte entspricht double.

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


version (old) {
struct fuzzy {

	double probability = 0.0;
	alias probability this;

public:
	/**
	* Ctor
	* Params:
	*		val = Wert zwischen 0 und 1
	**/
	this (double val) pure nothrow @safe @nogc {
		if (val > 1.0) this.probability = 1.0;
		else if (val < 0.0) this.probability = 0.0;
		else this.probability = val;
	}
	/**
	* Ctor
	* Params:
	* 	val = true oder false
	**/
	this (bool val) pure nothrow @safe @nogc {
		if (val) this.probability = 1.0;
		else this.probability = 0.0;
	}
	/**
	* Setzt den Wert zwischen 0 (false) und 1 (true).
	**/
	void setval(double val) pure nothrow @safe @nogc {
		if (val > 1.0) this.probability = 1.0;
		else if (val < 0.0) this.probability = 0.0;
		else this.probability = val;
	}
	/**
	* Erlaubt den Wert als bool zu setzen, wobei false 0 und true 1 enstspricht.
	**/
	void setval(bool val) pure nothrow @safe @nogc {
		if (val) this.probability = 1.0;
		else this.probability = 0.0;
	}

	/**
	* Gibt den Wert zwischen 0 und 1 zurück.
	**/
	double getval() const pure nothrow @safe @nogc {
		return this.probability;
	}
	string toString () @safe {
		import std.conv;
		return to!string(this.probability);
	}
	/** logical AND **/
	fuzzy opBinary(string op)(in fuzzy var) const pure nothrow @safe @nogc if (op == "&") {
		return (this.probability < var.probability)? fuzzy(this.probability) : fuzzy(var.probability);
	}
	/** logical AND für Typ bool **/
	fuzzy opBinary(string op)(in bool var) const pure nothrow @safe @nogc if (op == "&") {
		return (var)? fuzzy(this.probability) : fuzzy(0.0);
	}
	/** logical OR **/
	fuzzy opBinary(string op)(in fuzzy var) const pure nothrow @safe @nogc if (op == "|") {
		return (this.probability > var.probability)? fuzzy(this.probability) : fuzzy(var.probability);
	}
	/** logical OR für Typ bool **/
	fuzzy opBinary(string op)(in bool var) const pure nothrow @safe @nogc if (op == "|") {
		return (var)? fuzzy(1.0) : fuzzy(this.probability);
	}
	/** negation **/
	fuzzy opUnary(string op)() const pure nothrow @safe @nogc if (op == "-") {
		return fuzzy(1.0-this.probability);
	}
};
/** Anwendung **/
unittest {
	/** Initialisieren **/
	fuzzy f1 = 0.75;
	fuzzy f2 = true;
	assert (f1.getval == 0.75);
	assert (f2 == 1.0);

/** Logische Operationen **/
	f1 = 0.25;
	f2 = 0.5;
	fuzzy f3 = false;
	assert ((f1&f2) == 0.25);
	assert ((f1|f2) == 0.5);
	assert (-f1 == 0.75);
	assert ((f1&f2&f3) == 0);

/** Typ fuzzy **/
	assert (fuzzy.sizeof == double.sizeof);
	//assert (f1.stringof == "fuzzy");
}

unittest {
	assert (fuzzy(1.0) == 1.0);
	assert (fuzzy(false) == 0);
	assert (fuzzy(-0.25) == 0);
	assert (-fuzzy(0.25) == 0.75);
	assert ((fuzzy(0.75)&fuzzy(0.25)) == 0.25);
	assert ((fuzzy(0.75)|fuzzy(0.25)) == 0.75);
	assert ((fuzzy(0.25)&true) == 0.25);
	fuzzy f1 = true;
	fuzzy f2 = 0.25;
	assert (f1 == 1);
	assert ((f1&f2) == 0.25);
}
} // end version(old)
