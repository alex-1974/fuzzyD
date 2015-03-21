module fuzzyset;
import fuzzytype;
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
