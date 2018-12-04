import java.util.Stack;

//Array to store image hues
float[] numberArray;

//How many times to step in the sort algo per frame.
int stepSize;

//Needed for the version of the iterative quick sort that I used (thanks https://javarevisited.blogspot.com/2016/09/iterative-quicksort-example-in-java-without-recursion.html)
Stack stack;

void setup(){
  //Fits on my screen
  size(1000, 1000);
  background(0);
  reset();
}

void reset(){
  
  //create Array
  numberArray = new float[width];
  
  //Fill Array
  for (int i = 0; i < numberArray.length; i++){
    numberArray[i] = random(height);
  }
  
  //Make a stack and push initial values to it.
  stack = new Stack();
  stack.push(0);
  stack.push(numberArray.length);
  
  //Create a step size change the divisor higher for smaller steps but quicker animation and lower for less steps but quicker sorting, within reason.
  stepSize = 1;
  if(stepSize < 1) stepSize = 1;
  
}

void draw(){
  background(0);
  stroke(255);
  //Render array
  for (int i = 0; i < numberArray.length; i++){
    line(i, height, i, numberArray[i]);
  }
  
  //Make sure the stack has stuff in it to use.
  if(!stack.isEmpty()){
    for (int i = 0; i < stepSize; i++){
      //again for the done message to get called
      if(!stack.isEmpty()){
        //Set end and start to equal the current stack's knowledge of the array. initially the length of the array and then 0
        int end = (int) stack.pop();
        int start = (int) stack.pop();
        
        //Make sure that the ends have no crossed each other or are not already right next to each other.
        if(end - start >= 2){
          //pick the pivot for the partition algo
          int p = (int) random((float) start, (float) end);
          //Set P the the returned value from the partition algo
          p = Part(numberArray, p, start, end);
          
          //add to the stack the return part value + 1. Similar to a recursive call with an increased start
          stack.push(p + 1);
          stack.push(end);
          
          //add to the stack the return part value + 1 Similar to a recursive call with a decreased end
          stack.push(start);
          stack.push(p);
          
          //The stack is constantly moving the two "ends" being tested together eventual they will be right next to each other and the stack will be empty because nothing new will be added.
        }
      }else{
        //Look at the we done sorted!!
        System.out.println("DONE!");
        //reset();
        break;
      }
    }
  }
}

//Partition Algo
public int Part(float[] input, int position, int start, int end){
  // Start and end for the current "segement" of the array we are testing
  int l = start;
  int h = end - 2;
  
  //The pivot or value we are using to compare others in the "segement" to.
  float piv = input[position];
  
  //Put pivot at the end.
  swap(input, position, end - 1);

  //While where we have started is not where we are meant to end.
  while (l < h) {
    //Since pivot is already at the end if the value we are at the beginning testing is less than the pivot, do nothing ubt increase where we are starting
    if (input[l] < piv) {
      l++;
    //Since pivot is already at the end if the value we are testing at the end is more than the pivot, do nothing but decrease where we are ending
    } else if (input[h] >= piv) {
      h--;
    } else {
    //If the value at the begining is more than the pivot or the value at the end is less than the pivot swap'em.
      swap(input, l, h);
    }
  }
  
  //now our return should be the top most value
  int idx = h;
  //If the top most value is less than the pivot increase our return value.
  if (input[h] < piv) {
    idx++;
  }
  //Put our return value on the end of the "segement"
  swap(input, end - 1, idx);
  //return the value to continue the algo
  return idx;
}

//Utility to swap array entries
public void swap(float[] arr, int i, int j) {
  float temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}
