/**
*
* AND gives the smaller percent, OR gives the higher percent,
* and NOT gives the "opposite" percent. We'll define AND to be the smaller,
* OR to be the larger, and NOT to be (100% - given).
* See:
* <a href="http://www.thegeekstuff.com/2014/09/fuzzy-logic-cpp/">http://www.thegeekstuff.com/2014/09/fuzzy-logic-cpp/</a>
* <a href =""></a>
**/

module proof_of_concept.fuzzyD;

struct fuzzy {

protected:
	double probability = 0.0;
	//alias probability this;
public:
	this (double val) {
		if (val > 1.0) this.probability = 1.0;
		else if (val < 0.0) this.probability = 0.0;
		else this.probability = val;
	}
	this (bool val) {
		if (val) this.probability = 1.0;
		else this.probability = 0.0;
	}
	void setval(double val) {
		if (val > 1.0) this.probability = 1.0;
		else if (val < 0.0) this.probability = 0.0;
		else this.probability = val;
	}
	void setval(bool val) {
		if (val) this.probability = 1.0;
		else this.probability = 0.0;
	}
	double getval() const {
		return this.probability;
	}
	fuzzy and (fuzzy var) {
		if (this.probability < var.probability) return fuzzy(this.probability);
		else return fuzzy(var.probability);
	}
	fuzzy and (bool var) {
		if (var) return fuzzy(this.probability);
		else return fuzzy(false);
	}
	fuzzy or (fuzzy var) {
		if (this.probability > var.probability) return fuzzy (this.probability);
		else return fuzzy (var.probability);
	}
	fuzzy or (bool var) {
		if (var) return fuzzy (true);
		else return fuzzy (this.probability);
	}
	fuzzy not () {
		return fuzzy (1.0-this.probability);
	}
};

unittest {
	auto f1 = fuzzy();
	assert (f1.getval == 0.0);
	f1.setval(0.5);
	assert (f1.getval == 0.5);
	f1.setval (1.25);
	assert (f1.getval == 1.0);
	f1.setval (-0.25);
	assert (f1.getval == 0.0);
	f1.setval(true);
	assert (f1.getval == 1.0);
	f1.setval(0.75);
	auto f2 = fuzzy (0.25);
	assert (f1.and(f2).getval == 0.25);
	assert (f1.or(f2).getval == 0.75);
	assert (f1.and(true).getval == 0.75);
	assert (f1.and(false).getval == 0);
	assert (f1.or(true).getval == 1);
	assert (f1.or(false).getval == 0.75);
	assert (f1.not.getval == 0.25);
	assert (f2.not.getval == 0.75);
}

void main () {}
