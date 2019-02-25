/** Fuzzy rules
    Defuzzyfication:

    <em>Methods of deffuzification</em>
    <ul>
        <li>Center of Sums Method (COS)</li>
        <li>Center of Gravity (COG) / Centroid of Area (COA) Method</li>
        <li>Center of Area / Bisector of Area Method (BOA)</li>
        <li>Weighted Average Method</li>
        <li>Maxima Method</li>
        <ul>
            <li>First of Maxima Method (FOM)</li>
            <li>Last of Maxima Method (LOM)</li>
            <li>Mean of Maxima Method (MOM)</li>
        </ul>
    </ul>

    Center_of_Sums_(COS)_Method:

    <math>
        <msup><mi>X</mi><mn>*</mn></msup><mo>=</mo>
        <mfrac>
            <mrow>
                <msubsup>
                    <mo>&sum;</mo>
                    <mrow><mi>i</mi><mo>=</mo><mn>1</mn></mrow>
                    <mi>N</mi>
                </msubsup>
                <msub><mi>x</mi><mi>i</mi></msub><mo>&sdot;</mo>
                <msubsup>
                    <mo>&sum;</mo>
                    <mrow><mi>k</mi><mo>=</mo><mn>1</mn></mrow>
                    <mi>n</mi>
                </msubsup>
                <msub>
                    <mi>&micro;</mi>
                    <msub>
                        <mi>A</mi>
                        <mi>k</mi>
                    </msub>
                </msub>
                <mo>(</mo>
                    <msub><mo>x</mo><mo>i</mo></msub>
                <mo>)</mo>
            </mrow>
            <mrow>
                <msubsup>
                    <mo>&sum;</mo>
                    <mrow><mi>i</mi><mo>=</mo><mn>1</mn></mrow>
                    <mi>N</mi>
                </msubsup>
                <mspace width="1em"/>
                <msubsup>
                    <mo>&sum;</mo>
                    <mrow><mi>k</mi><mo>=</mo><mn>1</mn></mrow>
                    <mi>n</mi>
                </msubsup>
                <msub>
                    <mi>&micro;</mi>
                    <msub>
                        <mi>A</mi>
                        <mi>k</mi>
                    </msub>
                </msub>
                <mo>(</mo>
                    <msub><mo>x</mo><mo>i</mo></msub>
                <mo>)</mo>
            </mrow>
        </mfrac>
    </math>
**/
module fuzzyD.rules;
import fuzzyD.type;
import fuzzyD.set;

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
