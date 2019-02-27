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
class Member (T) if(isNumeric!T) {
    protected Fuzzy _value;
    /** **/
    @property auto getVal () const pure @safe nothrow @nogc {
        return this._value;
    }
    /** Membership function **/
    abstract Fuzzy setVal (T v) pure @safe;
    /** **/
    void setBounds (T[] v) {}
    /** **/
    alias getVal this;
}

/** **/
class Triangle(T) : Member!T {
    private T _left, _middle, _right;
    /** **/
    this (T left, T middle, T right) @safe pure nothrow @nogc {
        setBounds(left, middle, right);
    }
    /** **/
    override Fuzzy setVal (T v) pure @safe {
        if (this._left >= v || v >= this._right) this._value = Fuzzy(0);
        else if (v < _middle)   this._value = Fuzzy((v-_left)/(_middle-_left));
		else if (v == _middle)  this._value = Fuzzy(1.0);
		else if (v < _right)    this._value = Fuzzy((_right-v)/(_right-_middle));
        return this._value;
    }
    /** **/
    void setBounds (T left, T middle, T right) @safe pure nothrow @nogc {
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
    this (T left, T middleLeft, T middleRight, T right) pure @safe nothrow @nogc {
        setBounds(left, middleLeft, middleRight, right);
    }
    /** **/
    override Fuzzy setVal (T v) pure @safe {
        if (_left >= v || v >= _right) this._value = Fuzzy(0);
        else if (_middleLeft <= v && v <= _middleRight) this._value = Fuzzy(1.0);
        else if (v < _middleLeft)  this._value = Fuzzy((v-_left)/(_middleLeft-_left));
        else if (v < _right) this._value = Fuzzy((_right-v)/(_right-_middleRight));
        return this._value;
    }
    /** **/
    void setBounds (T left, T middleLeft, T middleRight, T right) pure @safe nothrow @nogc {
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
    Member!T[string] _member;
    /** **/
    void add (U...)(U member) {
        static if(member.length == 0) {
            return;
        }
        static if (member.length == 1) {
            static assert(0, "Wrong number of arguments!");
            return;
        }
        static if(member.length >= 2) {
            static assert(is(typeof(member[0]) == string), "Missing name of member!");
            static assert(is(typeof(member[1]) : Member!T), "Not a valid member!");
            this._member[member[0]] = member[1];
            add(member[2..$]);
            return;
        }
    }
    /** **/
    auto set (T value) {
        foreach (m; this._member) {
            m.setVal(value);
        }
        return _member;
    }
    /** **/
    auto get () {
        return _member;
    }
}

unittest {
    import std.typecons;
    auto temp = new Fuzzyset!double;
    temp.add("cold",triangle(1.0,2,3), "warm", trapezoid(2.0,3,4,5));
    double i = 0.0;
    do {
        writefln ("temp %s: %s", i, temp.set(i));
        i += 0.2;
    } while (i < 5.5);

}
