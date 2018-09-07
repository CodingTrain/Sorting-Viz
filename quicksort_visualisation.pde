//import java.util.Arrays;

//void help() {
//  println(Arrays.toString(values));
//}

ArrayList<Integer> lows = new ArrayList();
ArrayList<Integer> highs = new ArrayList();

float[] values;

void setup() {
  size(600, 400);
  frameRate(10);
  values = new float[width];
  for (int i = 0; i < values.length; i++) {
    values[i] = random(height);
  }
  lows.add(0);
  highs.add(values.length - 1);
}

void quicksort(float[] arr, int lo, int hi) {
  //println("Quicksort " + lo + " to " + hi);
  if (lo < hi) {
    int mid = partition(arr, lo, hi);
    lows.add(lo);
    highs.add(mid - 1);
    lows.add(mid + 1);
    highs.add(hi);
    //quicksort(arr, lo, mid-1);
    //quicksort(arr, mid+1, hi);
  }
}

int partition(float[] arr, int lo, int hi) {
  //println("Partition " + lo + " to " + hi);
  float pivot = arr[hi];
  int left = lo-1;
  int right = hi;
 
  while (left < right) {
    left++;
    if (arr[left] >= pivot) {
      while (right > left) {
        right--;
        if (arr[right] < pivot) {
          swap(arr, left, right);
          break;
        }
      }
    }
  }
  
  if (arr[left] > pivot)
    swap(arr, left, hi);
  return left;
}

void nextPart() {
  quicksort(values, lows.get(0), highs.get(0));
  lows.remove(0);
  highs.remove(0);
}

void draw() {
  background(0);
  int low = lows.get(0);
  int high = highs.get(0);
  nextPart();
  for (int i = 0; i < values.length; i++) {
    stroke(255);
    if (i >= low && i < high)
      stroke(255, 0, 0);
    line(i, height, i, height - values[i]);
  }
}


void swap(float[] arr, int a, int b) {
  //println("Swapping " + a + " for " + b);
  float temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
}