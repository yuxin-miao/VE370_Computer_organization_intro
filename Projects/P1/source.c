

int hot(int x) {
    if(x>=30) return 1;
    else return 0;
}
int cold(int x) {
    if (x<=5) return 1;
    else return 0;
}
int comfort(int x) {
    if (x>5 && x<30) return 1;
    else return 0;
}
int countArray(int A[], int numElements, int cntType) {
    int i, cnt = 0;
    for (i = numElements - 1; i >= 0; i--) {
        switch (cntType) {
            case 1: cnt += hot(A[i]); break;
            case -1: cnt += cold(A[i]); break;
            default: cnt += comfort(A[i]);
        }
    }
    return cnt;
}


int main() {
    int size = 32; //determine the size of the array here 
    int hotDay, coldDay, comfortDay;
    int tempArray[32] = {36, 9, -8, 40, 25, 20, 18, 19, 15, 16, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -3, -10, -19, -33};
    hotDay = countArray (tempArray, size, 1); 
    coldDay = countArray (tempArray, size, -1); 
    comfortDay = countArray (tempArray, size, 0);
}
