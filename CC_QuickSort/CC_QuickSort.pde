float[] values;

void setup() {
  size(600, 400);
  values = new float[width];
  for (int i = 0; i < values.length; i++) {
    values[i] = random(height);
  }
  noLoop();
}

void quicksort(float[] arr, int lo, int hi) {
  if (hi - lo == 2) {
    // Just two elements, we can swap manually
    if (arr[lo] > arr[hi-1]) swap(arr, lo, hi-1);
    return;
  } if (hi - lo < 2) {
    // Single elements
    return;
  }
  
  int mid = partition(arr, lo, hi);
  quicksort(arr, lo, mid);    
  quicksort(arr, mid+1, hi);
}

void mousePressed() {
  quicksort(values, 0, values.length);
}

void draw() {
  render();
}

// Working partition code from:
// https://www.geeksforgeeks.org/quick-sort/

//int partition (float arr[], int low, int high) {
//  float pivot = arr[high];  
//  int i = (low - 1);  
//  for (int j = low; j <= high- 1; j++) {
//    if (arr[j] <= pivot) {
//      i++;
//      swap(arr, i, j);
//    }
//  }
//  swap(arr, i+1, high);
//  return (i + 1);
//}

// I have slightly changed "hi", instead making it refer to after the last element
// This makes the code simpler

int partition(float[] arr, int lo, int hi) {
  float pivot = arr[hi-1];
  
  int i = lo-1;
  for (int j = lo; j < hi-1; j++) {
    if (arr[j] <= pivot) {
      swap(arr, ++i, j);
    }
  }
  
  swap(arr, ++i, hi-1);
  return i;
}



void render() {
  background(0);
  for (int i = 0; i < values.length; i++) {
    stroke(255);
    line(i, height, i, height - values[i]);
  }
}

void swap(float[] arr, int a, int b) {
  float temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;

  redraw();
}
