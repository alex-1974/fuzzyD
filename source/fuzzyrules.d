module fuzzyD.rules;
import fuzzy.type;
import fuzzy.set;

version (foo) {
struct rule {
	alias fuzzy delegate(double) outf;
	outf o;
	fuzzy i;
	string oname;
};
/**
* WENN ... DANN ...
* WENN in-fuzzyset (member ...) DANN out-fuzzyset (member)
* bei WENN ... UND ... DANN ...
* WENN wird zu in-fuzzyset = fuzzysetA und fuzzysetB
**/

class fuzzyRules {
	import std.stdio;
	rule[] ruleset;
	// empfangt die fuzzyMembers
	void addrule (T) (fuzzy infuzzy, T outfuzzy) {
		// zB abstand:niedrig, bremskraft:hoch
		rule r;
		r.i = &infuzzy;
		r.o = &outfuzzy.getValue;
		r.oname = outfuzzy.getName;
		ruleset ~= r;
	}
	fuzzyset[] calculate (double value) {
		fuzzyset[] result;
		// als resultat erhält man ein fuzzyset:
		// scharfe eingangsgröße wird jetzt angegeben
		// die entspricht je regel
		// einem infuzzy.member wert
		// dieser enspricht dem wert des outfuzzy.members;
		foreach (r; ruleset) {
			fuzzyset res;
			res.member = r.oname;
			res.value = r.i(value);
			result ~= res;
		}
		return result;
	}
	double gravity (fuzzyset[] fset, double[string] ovalue) {
		float up = 0;
		float down =0;
		//float x =0;
		foreach (r; fset) {
			up += (r.value*float(ovalue[r.member]));
			down += r.value;
		}
		if (down <= 0) return 0;
		assert (down > 0, "Division by Zero!");
		//x = up/down;
		return (up/down);
	}
};

}
