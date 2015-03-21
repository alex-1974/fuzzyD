/**
* Fuzzylogik (engl. fuzzy ‚verwischt‘, ‚verschwommen‘, ‚unbestimmt‘;
* fuzzy logic, fuzzy theory ‚unscharfe Logik‘ bzw. ‚unscharfe Theorie‘)
* ist eine Theorie, welche vor allem für die Modellierung von Unsicherheit und Vagheit von
* umgangssprachlichen Beschreibungen entwickelt wurde. Sie ist eine Verallgemeinerung der
* zweiwertigen Booleschen Logik. Beispielsweise kann damit die sogenannte Fuzziness von Angaben
* wie „ein bisschen“, „ziemlich“, „stark“ oder „sehr“ in mathematischen Modellen erfasst werden.
* Die Fuzzylogik basiert auf den Fuzzy-Mengen (Fuzzy-Sets) und sogenannten Zugehörigkeitsfunktionen,
* die Objekte auf Fuzzy-Mengen abbilden, sowie passenden logischen Operationen auf diesen Mengen
* und ihrer Inferenz. Bei technischen Anwendungen müssen außerdem Methoden zur
* Fuzzyfizierung und Defuzzyfizierung betrachtet werden, das heißt Methoden zur Umwandlung von
* Angaben und Zusammenhängen in Fuzzylogik und wieder zurück, zum Beispiel als Stellwert für eine Heizung als Resultat.
* (aus <a href="http://de.wikipedia.org/wiki/Fuzzylogik">http://de.wikipedia.org/wiki/Fuzzylogik</a>)
*
* AND gives the smaller percent, OR gives the higher percent,
* and NOT gives the "opposite" percent. We'll define AND to be the smaller,
* OR to be the larger, and NOT to be (100% - given).
* See:
* <a href="http://www.thegeekstuff.com/2014/09/fuzzy-logic-cpp/">http://www.thegeekstuff.com/2014/09/fuzzy-logic-cpp/</a>
* <a href =""></a>
**/

module fuzzy;

public import fuzzytype;
public import fuzzyset;
public import fuzzyrules;

void main () {
	/**
	*	erzeuge fuzzyset (temperatur = new fuzzyset)
	* insert members (temperatur.insert (kalt, triangle, intervall und range))
	* fuzzyset außentemp = temperatur (36);
	* außentemp.member[warm] == 0.6;
	*
	*
	**/
	import std.stdio;
	import std.conv;
	trapezoid langsam;
	langsam.setInterval(-5,40);
	langsam.setMiddle(0,30);
	langsam.setName("langsame Geschwindigkeit");
	triangle mittel;
	mittel.setInterval(30,60);
	mittel.setMiddle(35);
	mittel.setName("mittlere Geschwindigkeit");
	trapezoid schnell;
	schnell.setInterval(55,110);
	schnell.setMiddle(60,100);
	schnell.setName("hohe Geschwindigkeit");
	double dd = 50;
	auto d = dd;
	writeln (langsam.getValue(d));
	writeln (langsam.value);

version (foo) {
	auto near = new fuzzyMember!trapezoid;
	near.setInterval(-5,40);
	near.setMiddle(0,30);
	near.setName("entfernung_gering");
	auto middle = new fuzzyMember!triangle;
	middle.setInterval(30,60);
	middle.setMiddle(35,55);
	middle.setName("entfernung_mittel");
	auto far = new fuzzyMember!trapezoid;
	far.setInterval(55,110);
	far.setMiddle(60,100);
	far.setName("entfernung_groß");

	auto bremsleicht = new fuzzyMember!trapezoid;
	bremsleicht.setInterval (-5,40);
	bremsleicht.setMiddle(15,35);
	bremsleicht.setName("brems_leicht");
	auto bremsmittel = new fuzzyMember!trapezoid;
	bremsmittel.setInterval (35,75);
	bremsmittel.setMiddle(40,65);
	bremsmittel.setName("brems_mittel");
	auto bremshart = new fuzzyMember!trapezoid;
	bremshart.setInterval (70,105);
	bremshart.setMiddle(80,100);
	bremshart.setName("brems_hart");

	auto bremskraft = new fuzzySet("Bremskraft");
	bremskraft.insert(bremsleicht);
	bremskraft.insert(bremsmittel);
	bremskraft.insert(bremshart);
	auto geschwindigkeit = new fuzzySet("Geschwindigkeit");
	geschwindigkeit.insert(langsam);
	geschwindigkeit.insert(mittel);
	geschwindigkeit.insert(schnell);
	auto entfernung = new fuzzySet("Entfernung");
	entfernung.insert(near);
	entfernung.insert(middle);
	entfernung.insert(far);

	auto r = new fuzzyRules;
	double velo;
	auto r1 = langsam&far;
	writeln (r1);
	r.addrule(langsam, bremsleicht);
	r.addrule(mittel, bremsmittel);
	r.addrule(schnell, bremshart);

	uint x;
	while (x<100) {
		writef ("%s km/h ", x);
		auto t = r.calculate(x);
		double[string] mean;
		mean["brems_leicht"] = 10;
		mean["brems_mittel"] = 50;
		mean["brems_hart"] = 100;
		auto d = r.gravity(t, mean);
		writef ("%s ", d);
		write ("\n");
		x++;
	}


	auto x =0;
	while (x<75) {
		auto cost = price.get(x);
		writef ("x: %s ", x);
		write ("\n");
		x++;
	}
}
}
