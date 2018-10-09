module fuzzyD.type;

/**
* Fuzzy Typ erlaubt Wahrheitswerte von 0 bis 1.
* Erweitert den Typ bool, um Werte zwischen 0 (false) und 1 (wahr) darzustellen.
* Die Genauigkeit der möglichen Werte entspricht double.
*
**/
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
