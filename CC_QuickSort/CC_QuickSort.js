let values;

function setup() {
  createCanvas(600, 400);
  values = [];
  for (let i = 0; i < width; i++) {
    values[i] = random(height);
  }
  quicksort(values, 0, values.length - 1);
	console.log("Done!");
	noLoop();
}

function draw() {
	background(0);
  for (let i = 0; i < values.length; i++) {
    stroke(255);
    line(i, height, i, height - values[i]);
  }
}

function quicksort(arr, lo, hi) {
	setTimeout(() => {
		if (lo < hi) {
			let mid = partition(arr, lo, hi);
			quicksort(arr, lo, mid - 1);
			quicksort(arr, mid + 1, hi);
		}
		redraw();
	}, 10);
}

function partition(arr, low, high) {
  let pivot = arr[low];
  let i = low;
	let j = high+1;
	
	while (i < j) {
		while (arr[++i] < pivot && i < high){}
		while (arr[--j] >= pivot && j > low) {}
		if (i < j)
			swap(arr, i, j);
	}
	
	if (j != low)
		swap(arr, low, j);
	
	return j;
}

function swap(arr, a, b) {
  let temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
}