/*
 * Stephen Stafford - September 2018 <clothcat @ gmail.com>
 */

import java.util.Arrays;

/** 
 * Array to hold the original (unsorted) array - once generated this is left 
 * untouched as a reference.  We need to keep a copy of the original array
 * because we're going to first sort it (recording the swaps as we go) and 
 * then rerun the same swaps whillst rendering for visualisation.
 * this requires us to be able to get back to the original array
 */
float[] unsortedArray;

/** 
 * The array we're going to actually sort.  This will start out as a copy of the 
 * unsorted array.
 */
float[] beingSortedArray;

/** 
 * The record of which items we swapped as we sorted the array.  This is
 * an ArrayList rather than an array because an ArrayList will grow silently
 * as we add items to it (similarly to a Javastrint array) and we don't know
 * in advance how many swaps will be required to sort the array.
 */
ArrayList<Swap> swaps;

/** Counter to keep track of which step we're looking at whilst rendering the sort */
int swapStep = 0;

/** 
 * The number of swaps to do on each render interation (basically governs how 
 * fast the render happens.
 */
int swapsPerFrame = 3;

/** Processing setup method */
void setup() {
  size(1600, 700);
  // stop drawing until AFTER we've initially sorted the array
  noLoop();
  // create the randomised unsorteed array - this array is NOT manipulated
  // but remains untouched as a reference array.
  unsortedArray = makeUnsortedArray(width, height);
  // copy the unsorted array into beingSortedArray
  beingSortedArray = Arrays.copyOf(unsortedArray, unsortedArray.length);
  // sort the array recording the steps as we go along
  swaps = new ArrayList<Swap>();
  quicksortWithRecord(beingSortedArray, 0, beingSortedArray.length-1, swaps);

  // reset for drawing
  beingSortedArray = Arrays.copyOf(unsortedArray, unsortedArray.length);
  // start drawing now that everything is ready.
  loop();
}

/** Processing draw method */
void draw() {
  for (int i=0; i<swapsPerFrame; i++) {
    // advance the sort by one step
    Swap swap = swaps.get(swapStep);
    swapArrayElements(beingSortedArray, swap.a, swap.b);
    
    // ready for the next step
    swapStep++;
    // check we won't go past the end of the array
    if(swapStep>=swaps.size()){
      break;
    }
  }
  // draw the result
  render(beingSortedArray);

  // stop if we've finished
  if (swapStep >= swaps.size()) {
    noLoop();
    System.out.println("Finished");
  }
}

/**
 * run the Quicksort algorithm recording the steps as we go.
 *
 * This code is (almost exactly) the same as Dan's.
 */
void quicksortWithRecord(float[] arr, int lo, int hi, ArrayList<Swap> swapRecord) {
  if (lo < hi) {
    int mid = partitionWithRecord(arr, lo, hi, swapRecord);
    quicksortWithRecord(arr, lo, mid-1, swapRecord);    
    quicksortWithRecord(arr, mid+1, hi, swapRecord);
  }
}

/** 
 * Partition the array between lo and hi recording the swaps as we go.
 *
 * This code is almost exactly the same as Dan's.
 */
int partitionWithRecord (float arr[], int low, int high, ArrayList<Swap> swapRecord) {
  float pivot = arr[high];  
  int i = (low - 1);  
  for (int j = low; j <= high- 1; j++) {
    if (arr[j] <= pivot) {
      i++;
      recordedSwapArrayElements(arr, i, j, swapRecord);
    }
  }
  recordedSwapArrayElements(arr, i+1, high, swapRecord);
  return (i + 1);
}

/** 
 * Method to draw the given array on the screen.
 * THis code is directly copied from Dan's.
 */
void render(float[] arr) {
  background(0);
  for (int i = 0; i < arr.length; i++) {
    stroke(255);
    line(i, height, i, height - arr[i]);
  }
}

/** 
 * Generate an array of the specified size with values which range 
 * linearly from 0 to the specified maxValue.  We could just stick 
 * random numbers in here, but there's something pleasing to my OCD 
 * if the sorted array is a straight line...
 * 
 * @param arraySize the size of the array to create
 * @param maxValue the maximum value of the array to create
 */
float[] makeUnsortedArray(int arraySize, int maxValue) {
  float[] arr = new float[arraySize];
  for (int i=0; i<arr.length; i++) {
    arr[i] = map(i, 0, arr.length, 0, maxValue);
  }
  shuffle(arr);
  return arr;
}

/** 
 * Performs an in-place shuffle of the elements of the passed array using
 * the Fisher-Yates algorithm (which gives a slightly more uniform distribution
 * than the naive shuffle).
 * 
 * @see https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle 
 *
 * @param arr the array to shuffle 
 */
void shuffle(float[] arr) {
  for (int i=arr.length-1; i>0; i--) {
    int j = floor(random(0, i));
    swapArrayElements(arr, i, j);
  }
}

/** Swap in place two elements of a given array */
void swapArrayElements(float[] arr, int a, int b) {
  float temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
}

/**
 * swap two elements of an array and record which elements were swapped in an 
 * ArrayList of {@link Swap}
 */
void recordedSwapArrayElements(float[] arr, int a, int b, ArrayList<Swap> swapRecord) {
  Swap swap = new Swap(a, b);
  swapRecord.add(swap);
  swapArrayElements(arr, a, b);
}

/** Simple class to hold the two indices of a swap in an array */
class Swap {
  int a, b;
  Swap(int a, int b) {
    this.a=a;
    this.b=b;
  }

  /** toString method, handy for debugging with println statements */
  @Override
    public String toString() {
    return String.format("[%d, %d]", a, b);
  }
}
