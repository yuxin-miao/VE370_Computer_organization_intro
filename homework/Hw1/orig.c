
int addit(int a, int b) {
    return a + b;
}
int positive(int a, int b) {
    if (addit(a, b) > 0)
        return 1;
    else
        return 0; 
}

int main(){
    positive(3, -6);
}