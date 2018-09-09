import processing.sound.*;

// Variables that can be changed, the current values imitate the original quite accurately.

int numDancers = 10;                                         // number of values, if 10 use the fixed values array
boolean playMusic = true;                                    // much better with music ^^
int speedup = 0;                                             // positive values: speedup, negative values: slowdown
int startdelay = 600;                                        // 600 = 10 seconds delay in the start, lower for quicker quicksort action
int[] values = new int[] { 3, 0, 1, 8, 7, 2, 5, 4, 9, 6 };   // The values from the original are 3, 0, 1, 8, 7, 2, 5, 4, 9, 6

// sadly if (fullscreen) fullScreen(); else size(800, 600); doesn't work because they can't be used in the same sketch, even tho only one would be called

// Don't change these!
Dancer[] dancers = new Dancer[numDancers];

SoundFile song;

int pivot = -1;
int other = -1;

int lo = 0;
int hi = 0;

ArrayList<Integer> lows = new ArrayList();
ArrayList<Integer> highs = new ArrayList();

int delay = 10 - speedup;
int enddelay = 0;

void setup() {
  //fullScreen();
  size(800, 500);
  
  if (playMusic) {
    song = new SoundFile(this, "song.wav");
    song.play();
  }
  
  rectMode(CENTER);
  for (int i = 0; i < numDancers; i++) {
    if (numDancers != 10)
      dancers[i] = new Dancer(floor(random(numDancers)), i, numDancers);
    else
      dancers[i] = new Dancer(values[i], i, numDancers);
  }
  lows.add(0);
  highs.add(numDancers - 1);
}

// test variable
int count = 0;
void draw() {
  background(53);
  if (startdelay > 0) {
    startdelay--;
    if (startdelay == 0) {
      for (int i = 0; i < numDancers; i++) {
        dancers[i].idle = false;
      }
    }
  } else {
    count++;
    // " quick " sort
    if (pivot < 0) {
      if (lows.size() > 0) {
        pivot = lows.get(lows.size() - 1);
        lo = pivot;
        other = highs.get(highs.size() - 1);
        hi = other;
        lows.remove(lows.size() - 1);
        highs.remove(highs.size() - 1);
      } else {
        for (int i = 0; i < numDancers; i++) {
          dancers[i].idle = false;
          dancers[i].end = true;
        }
        pivot = -1;
        other = -1;
      }
    }
    if (pivot >= 0) {
      if (other < 0)
        other = 0;
      if (other >= numDancers)
        other = numDancers - 1;
      Dancer dl = dancers[pivot];
      Dancer dh = dancers[other];
      if (dl.finished() && dh.finished()) {
        //println("count: " + count);
        if (!dl.selected && !dh.deselected && !dl.done) {
          //println("Pivot = " + pivot);
          dl.pivot = true;
          dl.select();
        }
        if (dl.done) {
          pivot = -1;
        } else if (!dh.selected && !dh.deselected) {
          //println("P: " + pivot + " , O: " + other + " , pv: " + dl.value + " , ov: " + dh.value);
          dh.select();
          dh.other = true;
        } else if (dh.compared) {
          //println("compared");
          // swap
          if (dl.value > dh.value && pivot < other || dl.value < dh.value && pivot > other) {
            //println("Swapping " + pivot + " and " + other);
            swap(dancers, dl.index, dh.index);
            dl.moveTo(other);
            dh.moveTo(pivot);
            int temp = other;
            other = pivot;
            pivot = temp;
          } else {
            dh.deselect();
            checkDone(dl);
          }
        } else if (dh.swapped) {
          //println("after swapping");
          dh.deselect();
          checkDone(dl);
        } else if (dh.deselected) {
          if (!dl.done) {
            if (dl.index < dh.index) {
              if (other > lo) {
                other--;
              }
            } else {
              if (other < hi)
                other++;
            }
          }
          if (other == pivot)
            dl.other = true;
          dh.deselected = false;
        } else {
          //println("waiting");
          dh.compare();
        }
      }
    }
  }
  int done = numDancers;
  for (int i = 0; i < numDancers; i++) {
    if (dancers[i].done)
      done--;
    if (i != pivot && i != other || startdelay > 0 || pivot < 0 || pivot >= numDancers || other < 0 || other >= numDancers)
      dancers[i].show();
  }
  if (startdelay <= 0) {
    if (other >= 0 && other < numDancers)
      dancers[other].show(); 
    if (pivot >= 0 && pivot < numDancers && pivot != other) 
      dancers[pivot].show();
  } else {
    float alpha = startdelay / 600.0 * 255;
    fill(0, alpha);
    rect(width / 2, height / 2, width, height);
  }
  if (done <= 0) {
    enddelay++;
    float alphaText = (enddelay - 1500.0) / 300 * 255;
    if (alphaText > 0) {
      fill(0, alphaText);
      rect(width / 2, height / 2, width, height);
      fill(255, alphaText);
      textSize(60);
      text("Hope you enjoyed!", width / 2, height / 2);
    }
    if (enddelay >= 3000) {
      noLoop();
    }
  }
}

void checkDone(Dancer dl) {
  if (pivot == other) {
    dl.done = true;
    dl.other = true;
    boolean divided = false;
    //println("done " + dl.index);
    if (pivot + 1 < numDancers) {
      if (!dancers[pivot + 1].done) {
        divided = true;
        //println("adding " + (pivot + 1) + ", " + hi);
        lows.add(pivot + 1);
        highs.add(hi);
      }
    }
    if (pivot - 1 >= 0) {
      if (!dancers[pivot - 1].done) {
        divided = true;
        //println("adding " + lo + ", " + (pivot - 1));
        lows.add(lo);
        highs.add(pivot - 1);
      }
    }
    if (divided) {
      dl.wait = 36 * delay;
      dl.addDelay = true;
    }
  }
}

void swap(Dancer[] arr, int a, int b) {
  Dancer temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
}
