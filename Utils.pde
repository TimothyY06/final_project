public class UtilsEl {
  double getMax(double num1, double num2) {
    if(num1 > num2)
      return num1;
     return num2;
  }
  
  double getMin(double num1, double num2) {
    if(num1 > num2)
      return num2;
     return num1;
  }
  
  double average(double num1, double num2) {
    return (num1 + num2) / 2;
  }
}
