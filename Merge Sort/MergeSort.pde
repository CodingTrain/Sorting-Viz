float[] values;

int count = 0;

void setup() {
  size(600, 400);
//  fullScreen();
  values = new float[width];
  for (int i = 0; i < values.length; i++) {
    values[i] = random(height);
  }
}

void draw() {
  background(0);
  
  if(count < width){
    mergeSort(values, 0, values.length-1);
  }
  
  for (int i = 0; i < values.length; i++) {
    stroke(255);
    line(i, height, i, height - values[i]);
  }
  
  count++;
}

void mergeSort(float[] arr, int p, int r)
{  
  if(p < r) {
    int q = (p + r)/2;
    mergeSort(arr, p, q);
    mergeSort(arr, q+1, r);
    merge(arr, p, q, r);
  }
  else{
    return;
  }
}

void merge(float[] arr, int p, int q, int r)
{
  int n1 = q - p + 1;
  int n2 = r - q;

  float[] leftArr = new float[n1];
  float[] rightArr = new float[n2];
  
  int i, j, k;
  
  for( i = 0; i < n1; i++ )
    leftArr[i] = arr[p + i];
  
  for( j = 0; j < n2; j++ )
    rightArr[j] = arr[q + j + 1];

  i = j = 0;
  k = p;
  
  while (i < n1 && j < n2) 
  { 
    if (leftArr[i] <= rightArr[j]) 
    { 
        arr[k] = leftArr[i++];
    } 
    else
    { 
        arr[k] = rightArr[j++];
    }
    k++;
}

  while (i < n1) 
  { 
      arr[k++] = leftArr[i++];
  } 

  while (j < n2) 
  { 
      arr[k++] = rightArr[j++];
  }
}
