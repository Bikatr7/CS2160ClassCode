
#include <stdio.h>

int gets(char *s)
{
  char *p = s;
  int last_read;
  
  do {
    last_read = getchar();
    if (last_read < 0) {
      return last_read;
    }
    *p++ = (char)last_read;
  } while (last_read != '\n');
  p[-1] = 0;
  return s-p;
}

int puts(const char *s)
{
  char c;
  while (c = *s++) if (putchar(c) < 0) return -1;
  putchar('\n');
  return 0;
}


char *str = "Enter a message: ";
void main(void)
{
  char buf[100];
  puts(str);
  gets(buf);
  puts(buf);
}


