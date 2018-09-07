import java.util.Arrays;

void help() {
  println(Arrays.toString(values));
}

float[] values;

void setup() {
  values = new float[] {2, 8, 5, 7, 9, 3, 4};
  help();
  quicksort(values, 0, values.length-1);
  help();
}

void quicksort(float[] arr, int lo, int hi) {
  println("Quicksort " + lo + " to " + hi);
  if (lo < hi) {
    int mid = partition(arr, lo, hi);
    quicksort(arr, lo, mid-1);
    quicksort(arr, mid+1, hi);
  }
}

int partition(float[] arr, int lo, int hi) {
  println("Partition " + lo + " to " + hi);
  float pivot = arr[hi];
  int left = lo-1;
  int right = hi-1;
  
  if (lo == right) {
   return lo; 
  }
 
  while (left < right) {
    left++;
    if (arr[left] >= pivot) {
      while (right > left) {
        if (arr[right] < pivot) {
          swap(arr, left, right);
          break;
        }
        right--;
      }
    }
  }
  
  swap(arr, left, hi);
  return left;
}


//void draw() {
//  background(0);
//  for (int i = 0; i < values.length; i++) {
//    stroke(255);
//    line(i, height, i, height - values[i]);
//  }
//}

void swap(float[] arr, int a, int b) {
  println("Swapping " + a + " for " + b);
  float temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
}
