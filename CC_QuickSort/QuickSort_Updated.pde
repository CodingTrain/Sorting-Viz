
float[] values;

int i, j;

void setup() {
  size(600, 400);
  values = new float[width];
  for (int i = 0; i < values.length; i++) {
    values[i] = random(height);
  }
}

void quicksort(float[] arr, int lo, int hi) {
  if (lo < hi) {
    int mid = partition(arr, lo, hi);
    quicksort(arr, lo, mid-1);    
    quicksort(arr, mid+1, hi);
  }
}

void mousePressed() {
  quicksort(values, 0, values.length-1);
}

void draw() {
  background(0);
  for (int i = 0; i < values.length; i++) {
    stroke(255);
    line(i, height, i, height - values[i]);
  }
}

int partition (float arr[], int left, int right) 
{ 
    float pivot = arr[right];    // pivot 
    i = left - 1;  // Index of smaller element 
    
    for(j = left; j <= right - 1; j++){
      if( arr[j] <= pivot){
        i++;
        if(arr[i] != arr[j]){
          swap(arr, i, j);
          break;
        }
      }
    }
    swap(arr, i+1, j);
    return i+1;
}

void swap(float[] arr, int a, int b) {
  float temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
  redraw();
}
