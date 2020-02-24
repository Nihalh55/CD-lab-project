/*Test case for binary search in c*/

#include <stdio.h>

int main()
{
  int c, first, last, middle, search, array[5]={1,3,5,10,11},found;
  search=10;
  first = 0;
  last = n - 1;
  middle = (first+last)/2;

  while (first <= last) {
    if (array[middle] < search)
      first = middle + 1;
    else if (array[middle] == search) {
      found=middle+1;
      break;
    }
    else
      last = middle - 1;

    middle = (first + last)/2;
  }
  if (first > last)
    return -1;

  return found;
}
