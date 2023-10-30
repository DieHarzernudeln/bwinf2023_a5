//Initialisierung
String[] bedingung;
String[] route;
String[] stationL;
String[] wegL;
int indexRoute = 1;
int laenge = 0;

void setup() {
  //Einlesen der Datei
  bedingung = loadStrings("tour1.txt");
  //Länge der ursprünglichen Route
  int l = Integer.parseInt(bedingung[0]);
  //Initialisiere das Array route mit der richtigen Größe
  route = new String[l];
  //Setze das erste Element von route
  route[0] = addInfo(1);
  //alle Stationen abfragen
  for (int i = 2; i < l+1; i++) {
    //Station wird mehrmals besucht (=doppelt)
    int duplicateIndex = doppelt(i, l);
    if (duplicateIndex != 0) {
      //kein wichtiger Stopp dazwischen
      if (wichtigIndex(i, duplicateIndex)==0) {
        //erster Besuch wichtig
        if (wichtig(i)) {
          route[indexRoute] = addInfo(i);
          indexRoute += 1;
        }
        //zweiter Besuch oder keiner wichtig
        if (wichtig(duplicateIndex)||!wichtig(i)) {
          route[indexRoute] = addInfo(duplicateIndex);
          indexRoute += 1;
        }
        //Weg bis zum ersten Besuch
        laenge = laenge + weg(i-1, i);
        i=duplicateIndex;
      }
      //wichtiger Stopp dazwischen
      else if (wichtigIndex(i, duplicateIndex)!=0) {
        //doppelte Station zwischen erstem und zweitem Besuch
        for (int j=i; j<wichtigIndex(i, duplicateIndex); j++) {
          //Station an Index j wird zweimal besucht
          if (doppelt(j, wichtigIndex(i, duplicateIndex))!=0) {
            route[indexRoute] = addInfo(j);
            indexRoute += 1;
            laenge = laenge + weg(j-1, j);
            //i hat Index des zweiten Besuchs
            i=doppelt(j, wichtigIndex(i, duplicateIndex));
          }
          //j wird nicht zweimal besucht, kann also nicht übersprungen werden
          else {
            route[indexRoute] = addInfo(j);
            indexRoute += 1;
            laenge = laenge + weg(j-1, j);
            i=j;
          }
        }
      }
    }
    //Station ist nicht doppelt, muss also besucht werden
    else {
      route[indexRoute] = addInfo(i);
      indexRoute += 1;
      laenge = laenge + weg(i-1, i);
    }
  }
  print("Die Route besteht aus den folgenden Stationen: ");
  int index=0;
  while (route[index+1]!=null) {
    print(route[index] + " -> ");
    index += 1;
  }
  print(route[index]);
  println(" und ist " + laenge + " Einheiten lang.");
}

//Funktionen
/*Prüft, ob die Station mehrmals besucht wird und gibt 
dann den Index des nächten Besuchs zurück*/
public int doppelt(int start, int ende) {
  String geg = nameStation(start);
  //systematisches Abfragen aller weiteren Stationen
  for (int i = start + 1; i < ende; i++) {
    String ges = nameStation(i);
    if (geg.equals(ges)) {
      return i;
    }
  }
  return 0;
}
//Gibt Namen der Station zurück
public String nameStation(int index) {
  stationL = split(bedingung[index], ',');
  String station = stationL[0];
  return station;
}
//Gibt zurück, ob die Station essenziell ist
boolean wichtig(int index) {
  if (bedingung[index].contains("X")) {
    return true;
  } else {
    return false;
  }
}
//Gibt Index einer essenziellen Station (in einem Bereich) wieder
public Integer wichtigIndex(int start, int ende) {
  for (int i=start+1; i<ende; i++) {
    if (wichtig(i)) {
      return i;
    }
  }
  return 0;
}
//Gibt Name der Station und das entsprechende Jahr zurück
public String addInfo(int index) {
  stationL = split(bedingung[index], ',');
  String station = stationL[0];
  station += ", ";
  station += (stationL[1]);
  return station;
}
//Berechnet den Weg zwischen zwei Stationen
public Integer weg(int index1, int index2) {
  wegL = split(bedingung[index1], ',');
  //Aus dem Array die Länge auslesen und Leerzeichen entfernen
  int weg = Integer.parseInt(wegL[3].trim());
  wegL = split(bedingung[index2], ',');
  weg = Integer.parseInt(wegL[3].trim())-weg;
  return weg;
}
