/**

TODO:
    <ul>
        <li>add singleton, bell-shaped and gauss-shaped members</li>
        <li>find better name for <em>setBounds</em></li>
    </ul>
**/
module fuzzyD.set;

import fuzzyD.type;
import std.traits;
debug import std.stdio;

/** **/
abstract class Member (T) if(isNumeric!T) {
    protected Fuzzy _value;
    /** **/
    @property auto getVal () const pure @safe nothrow @nogc {
        return this._value;
    }
    /** Membership function **/
    abstract Fuzzy setVal (T) (T v) pure @safe;
    /** **/
    abstract void setBounds (T) (T[] v);
    /** **/
    alias getVal this;
}

/** **/
class Triangle(T) : Member!T {
    private T _left, _middle, _right;
    /** **/
    this (T) (T left, T middle, T right) @safe pure nothrow @nogc {
        setBounds(left, middle, right);
    }
    /** **/
    final Fuzzy setVal (T) (T v) pure @safe {
        if (this._left >= v || v >= this._right) this._value = Fuzzy(0);
        else if (v < _middle)   this._value = Fuzzy((v-_left)/(_middle-_left));
		else if (v == _middle)  this._value = Fuzzy(1.0);
		else if (v < _right)    this._value = Fuzzy((_right-v)/(_right-_middle));
        return this._value;
    }
    /** **/
    final void setBounds (T) (T left, T middle, T right) @safe pure nothrow @nogc {
        this._left = left;
        this._middle = middle;
        this._right = right;
    }
}
/** **/
auto triangle (T) (T left, T middle, T right) @safe pure {
    return new Triangle!T(left, middle, right);
}

@safe unittest {
    auto cold = new Triangle!double(1.0,2,3);
    writefln ("cold 1: %s", cold.setVal(1.0));
    writefln ("cold 2: %s", cold.setVal(2.0));
    writefln ("cold 3: %s", cold.setVal(3.0));
    writefln ("cold 1.5: %s", cold.setVal(1.5));
    writefln ("cold 2.5: %s", cold.setVal(2.5));
}
@safe unittest {
    auto hot = triangle(1.0,2,3);
    writefln ("hot 2.5: %s", hot.setVal(2.5));

}

/** **/
class Trapezoid(T) : Member!T {
    private T _left, _middleLeft, _middleRight, _right;
    /** **/
    this (T) (T left, T middleLeft, T middleRight, T right) pure @safe nothrow @nogc {
        setBounds!T(left, middleLeft, middleRight, right);
    }
    /** **/
    final Fuzzy setVal (T) (T v) pure @safe {
        if (_left >= v || v >= _right) this._value = Fuzzy(0);
        else if (_middleLeft <= v && v <= _middleRight) this._value = Fuzzy(1.0);
        else if (v < _middleLeft)  this._value = Fuzzy((v-_left)/(_middleLeft-_left));
        else if (v < _right) this._value = Fuzzy((_right-v)/(_right-_middleRight));
        return this._value;
    }
    /** **/
    final void setBounds (T) (T left, T middleLeft, T middleRight, T right) pure @safe nothrow @nogc {
        this._left = left;
        this._middleLeft = middleLeft;
        this._middleRight = middleRight;
        this._right = right;
    }
}
/** **/
auto trapezoid (T) (T left, T middleLeft, T middleRight, T right) @safe pure {
    return new Trapezoid!T(left, middleLeft, middleRight, right);
}

@safe unittest {
    auto warm = new Trapezoid!double(1.0,2,3,4);
    writefln ("warm 1: %s", warm.setVal(1.0));
    writefln ("warm 2: %s", warm.setVal(2.0));
    writefln ("warm 3: %s", warm.setVal(3.0));
    writefln ("warm 4: %s", warm.setVal(4.0));
    writefln ("warm 1.5: %s", warm.setVal(1.5));
    writefln ("warm 2.5: %s", warm.setVal(2.5));
    writefln ("warm 3.5: %s", warm.setVal(3.5));
}
@safe unittest {
    auto hot = trapezoid(1.0,2,3,4);
    writefln ("hot 3.5: %s", hot.setVal(3.5));

}

class Fuzzyset (T) {
    import std.meta;
    //alias TypeTuple!(string, Member!T) M;
    alias Params = AliasSeq!(string, Member!T);
    Member!T[string] _member;
    void add (Params...)(Params member) {
        pragma(msg, "members: ", member.length);
        static if(member.length == 0) {
            pragma(msg, "zero");
            return;
        }
        static if (member.length == 1) {
            pragma(msg, "one");
            static assert(0, "Wrong number of arguments!");
            return;
        }
        else if(member.length >= 2) {
            import std.traits;
            pragma(msg, "multiple");
            static assert(is(typeof(member[0]) == string));
            static assert(is(typeof(member[1]) : Member!T));
            //is(BaseClassesTuple!C1 == AliasSeq!(Object)));
            this._member[member[0]] = member[1];
            add(member[2..$]);
            return;
        }
    }
}

unittest {
    import std.typecons;
    auto temp = new Fuzzyset!double;
    temp.add("cold",triangle(1.0,2,3), "warm", trapezoid(4.0,5,6,7), "hot", "fail");
}

version (old) {
/**
* Type Fuzzyset erlaubt Set an Wahrheitswerten zwischen 0 bis 1
*
**/
struct fuzzyset {
	string member;
	fuzzy value;
};

/**
* Faßt die Fuzzymember zu Fuzzysets zusammen.
**/
class fuzzySet {
protected:
	alias fuzzy delegate(double) m;
	m[string] members;
	string name;
public:
  /** Konstruktor **/
	this (string name) { this.name = name; }
	/** Füge Member zum Set hinzu. **/
	void insert (T) (T ft) { members[ft.sName] = &ft.getValue; }
	/** Entferne Member aus dem Set. **/
	void remove (T) (T ft) { members.remove(ft.sName); }

  /** Gib Liste der Members mit den fuzzy Werten retour **/
  fuzzyset[] get () {
    fuzzyset[] n;
    return n;
  }
  /** Gib Liste der Members für diesen Wert retour **/
	fuzzyset[] get (double t) {
		fuzzyset[] n;
		foreach (key, func; members) {
			fuzzyset k;
			k.member = key;
			k.value = func(t);
			n ~= k;
		}
		return n;
	}
};

/**
* Container für Member von Fuzzy Sets
**/
struct fuzzymember {
	string name;                        /// Adjektiv des Members
	fuzzy delegate (double) getValue;   /// Funktion, die fuzzy Wert errechnet.
	fuzzy value = 0;                        /// Speichert den fuzzy Wert aus der Berechnung
};

/** Mixin für Member **/
mixin template mixinmember () {

public:
  fuzzymember member;
	alias member this;
	/** Setzt das Intervall **/
	void setInterval (double l, double r) { dLeft=l; dRight=r; }
	/** Setz Name des Members **/
  void setName (string s) {
	  member.name = s;
	}
	/** Ist der Wert innerhalb des Intervalls **/
  bool inInterval(double t) {
		if((t>=dLeft) && (t<=dRight)) return true;
    else return false;
	}
	fuzzy getValue () {
    return value;
	}
	/** Gib Name des Members retour **/
  string getName () const { return ( member.name); }
  //fuzzymember get () { return member; }
};

/**
* Member mit dreieckiger Kurve
**/
struct triangle {
private:
	double dMiddle, dLeft, dRight;
public:
  mixin mixinmember;
	void setMiddle(double dM) { dMiddle=dM; }
	fuzzy getValue () { return value; }
	fuzzy getValue (double t) {
    if      (t<=dLeft)    value = fuzzy(0);
		else if (t<dMiddle)   value = fuzzy((t-dLeft)/(dMiddle-dLeft));
		else if (t==dMiddle)  value = fuzzy(1.0);
		else if (t<dRight)    value = fuzzy((dRight-t)/(dRight-dMiddle));
		else                  value = fuzzy(0);
		return value;
	}
};
/** dreieckige Kurve **/
unittest {
  triangle t;
  t.setInterval(-5,20);
  assert (t.inInterval(10) == true);
  t.setName("kalt");
  assert (t.getName() == "kalt");
  assert (t.getValue == 0);
  t.setMiddle(15);
  assert (t.getValue(15) == 1);
  assert (t.getValue() == 1);
}

/**
* Member mit trapezoider Kurve
**/
struct trapezoid {

private:
	double dLeftMiddle, dRightMiddle, dLeft, dRight;
public:
  mixin mixinmember;
  void setMiddle (double dL, double dR) {
		dLeftMiddle=dL; dRightMiddle=dR;
	}
	fuzzy getValue () { return value; }
	fuzzy getValue (double t) {
		if      (t<=dLeft)        value = fuzzy(0);
		else if (t<dLeftMiddle)   value = fuzzy((t-dLeft)/(dLeftMiddle-dLeft));
		else if (t<=dRightMiddle) value = fuzzy(1.0);
		else if (t<dRight)        value = fuzzy((dRight-t)/(dRight-dRightMiddle));
		else                      value = fuzzy(0);
		return value;
	}
};
/** trapezoide Kurve **/
unittest {
  trapezoid t;
  t.setInterval(20,40);
  assert (t.inInterval(30) == true);
  t.setName("warm");
  assert (t.getName() == "warm");
  t.setMiddle(25,35);
  assert (t.getValue(30) == 1);
  assert (t.getValue() == 1);
}
} // end version(old)
