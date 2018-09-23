String[] names;
int[] alreadyGone;
Table table;
PFont f;
int chosen = 0;
boolean allowMouse = true;

void setup() {
  size(640, 360);
  loadData();
  f = createFont("Monaco", 32);
  textFont(f, 32);
  textAlign(CENTER);
}

void draw() {
  background(127);
  chosen = (int)random(8);
  text(names[chosen], width/2, height/2);
}

void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  table = loadTable("table.csv", "header");

  names = new String[table.getRowCount()]; 
  alreadyGone = new int[table.getRowCount()]; 

  // You can access iterate over all the rows in a table
  for (int i = 0; i < table.getRowCount(); i++) {
    TableRow row = table.getRow(i);
    // You can access the fields via their column name (or index)
    names[i] = row.getString("name");
    alreadyGone[i] = row.getInt("alreadyGone");
  }
  printArray(names);
  printArray(alreadyGone);
}

void mousePressed() {
  if (allowMouse) {
    allowMouse=false;
    int i = 0;
    while (alreadyGone[chosen]==1 && i < 1000) {
      chosen = (int)random(8);
      i++;
    }
    if (alreadyGone[chosen]==0) {
      table.setInt(chosen, "alreadyGone", 1);
      // Writing the CSV back to the same file
      saveTable(table, "data/table.csv");
      background(127);
      text(names[chosen], width/2, height/2);
    } else {
      background(127);
      text("Everyone has gone already", width/2, height/2);
    }
    noLoop();
  }
}

void keyPressed() {
  if (key=='c') {
    for (int i=0; i<8; i++) {
      table.setInt(i, "alreadyGone", 0);
      // Writing the CSV back to the same file
      saveTable(table, "data/table.csv");
      loadData();
    }
  }
}