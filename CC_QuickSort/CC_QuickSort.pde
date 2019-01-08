import java.util.ArrayDeque;

float[] values;

// To animate the algorithm
// I implemented the recursive quicksort on my own stack
// I can run through the stack as I please
// So I pop the stack each frame and process one per frame
ArrayDeque<int[]> qs_stack;

void setup() {
  size(600, 400);
  values = new float[width];
  for (int i = 0; i < values.length; i++) {
    values[i] = random(height);
  }
  
  // Create stack
  qs_stack = new ArrayDeque<int[]>();
  
  // Initial call of quicksort
  int[] params = {0, values.length};
  qs_stack.addFirst(params);
}

// I have slightly changed "hi", instead making it refer to after the last element
// This makes the code simpler

int partition(int lo, int hi) {
  float pivot = values[hi-1];
  
  int i = lo-1;
  for (int j = lo; j < hi-1; j++) {
    if (values[j] <= pivot) {
      swap(++i, j);
    }
  }
  
  swap(++i, hi-1);
  return i;
}

void draw() {
  // Pop!
  int[] qs_params = qs_stack.pollFirst();

  if (qs_params != null) {
    
    if (qs_params[0] < qs_params[1]) {
      // Partition the array
      int mid = partition(qs_params[0], qs_params[1]);
    
      // The parameters for the next calls
      int[] left  = {qs_params[0], mid};
      int[] right = {mid+1, qs_params[1]};
      
      // Push to the stack!
      qs_stack.addFirst(right);
      qs_stack.addFirst(left);
      

      // Animate!
      background(0);
  
      // Sorted elements, green
      stroke(0, 255, 0);
      for (int i = 0; i < qs_params[0]; i++) {
        line(i, height, i, height - values[i]);
      }
      
      // To sort - left side, red
      stroke(255, 0, 0);
      for (int i = qs_params[0]; i < mid; i++) {
        line(i, height, i, height - values[i]);
      }
      
      // Pivot point, red
      stroke(0, 0, 255);
      line(mid, height, mid, height - values[mid]);
      
      // To sort - right side, red
      stroke(255, 0, 0);
      for (int i = mid + 1; i < qs_params[1]; i++) {
        line(i, height, i, height - values[i]);
      }
      
      // The rest of the elements, white
      stroke(255);
      for (int i = qs_params[1]; i < values.length; i++) {
        line(i, height, i, height - values[i]);
      }
    }
  } else {

    // If the stack is empty, we have finished the sort
    // Lets start again!
    setup();
  }
}

void swap(int a, int b) {
  float temp = values[a];
  values[a] = values[b];
  values[b] = temp;

  redraw();
}
