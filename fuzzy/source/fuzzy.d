module proof_of_concept.fuzzy;

class DFuzzyFunction {

protected:
	double  dLeft, dRight;
	dchar   cType;
	string  sName;

public:
	void setInterval (double l, double r) { dLeft=l; dRight=r; }
  abstract void setMiddle (double dL=0, double dR=0);
  void setType (char c) { cType=c;}
  void setName (string s) {
	  sName = s;
	}
  bool isDotInInterval(double t) {
		if((t>=dLeft) && (t<=dRight)) return true;
    else return false;
	}
	dchar getType () const{ return cType; }
  void getName () const { import std.stdio; write (sName); }
	abstract double getValue (double t);

}

class DTriangle : DFuzzyFunction
{
private:
	double dMiddle;

public:
	override void setMiddle(double dL, double dR) { dMiddle=dL; }
	override double getValue(double t) {
		if      (t<=dLeft)    return 0;
		else if (t<dMiddle)   return (t-dLeft)/(dMiddle-dLeft);
		else if (t==dMiddle)  return 1.0;
		else if (t<dRight)    return (dRight-t)/(dRight-dMiddle);
		else                  return 0;
	}
};

class DTrapezoid : DFuzzyFunction
{
private:
	double dLeftMiddle, dRightMiddle;

public:
  override void setMiddle (double dL, double dR) {
		dLeftMiddle=dL; dRightMiddle=dR;
	}
	override double getValue(double t) {
		if      (t<=dLeft)        return 0;
		else if (t<dLeftMiddle)   return (t-dLeft)/(dLeftMiddle-dLeft);
		else if (t<=dRightMiddle) return 1.0;
		else if (t<dRight)        return (dRight-t)/(dRight-dRightMiddle);
		else                      return 0;
	}
};

double cdMinimumPrice =0;
double cdMaximumPrice =70;

void main () {
  import std.stdio;

  DFuzzyFunction FuzzySet[3];

	FuzzySet[0] = new DTrapezoid;
	FuzzySet[1] = new DTriangle;
	FuzzySet[2] = new DTrapezoid;

	FuzzySet[0].setInterval(-5,30);
	FuzzySet[0].setMiddle(0,20);
	FuzzySet[0].setType('r');
	FuzzySet[0].setName("low_price");

	FuzzySet[1].setInterval(25,45);
	FuzzySet[1].setMiddle(35,35);
	FuzzySet[1].setType('t');
	FuzzySet[1].setName("good_price");

	FuzzySet[2].setInterval(40,75);
	FuzzySet[2].setMiddle(50,70);
	FuzzySet[2].setType('r');
	FuzzySet[2].setName("to_expensive");

	writeln ("#####################################");
	writeln ("Example of fuzzy logic in D");
	writeln ("Input a value between ", cdMinimumPrice, " and ", cdMaximumPrice, ".");
	writeln ("Try these values: -10, 0, 15, 27, 25, 35, 48, 46, 50, 70 and 75");
	writeln ("Exit with Ctrl-C\n");
	writeln ("#####################################\n");
  double dValue;
  do
	{
	  write ("Imput the value: ");
	  readf(" %s", &dValue);

	  if(dValue<cdMinimumPrice) continue;
	  if(dValue>cdMaximumPrice) continue;

    for(int i=0; i<3; i++) {
		 writeln ("\nThe dot is ", dValue);
		 if(FuzzySet[i].isDotInInterval(dValue))
			 writeln ("In the interval");
		 else
			 writeln ("Not in the interval");

     write ("The name of function is ");
		 FuzzySet[i].getName();
		 write (" and the membership is ");
		 writeln (FuzzySet[i].getValue(dValue));
	  }
	}
	while(true);
}
