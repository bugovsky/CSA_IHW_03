#include <stdio.h>
#include <math.h>

double calculateRoot(double prev, double curr, double num, double eps) {
    while (fabs(prev - curr) > eps) {
        prev = curr;
        curr = (4 * prev + num / (prev * prev * prev * prev)) / 5.0;
    }
    return curr;
}

int main() {
    double number;
    scanf("%lf", &number);
    if (number == 0.0) {
        printf("%lf\n", number);
        return 0;
    }
    double eps = 0.001;
    double prediction = number / 5.0;
    double current = (4 * prediction + number / (prediction * prediction * prediction * prediction)) / 5.0;
    current = calculateRoot(prediction, current, number, eps);
    printf("%lf\n", current);
    return 0;
}
