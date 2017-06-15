/*
##
## Trabajo Practico Nro 3:
##
##   Ejercicio 03
##
##
##  Trabajo Práctico N°3 - Ejercicio 3 - 1° Entrega
##  Integrantes:
##  Matias Ezequiel Cairo 39670522
##	Thomas Ignacio Reynoso 39332450
##	Pablo Avalo 39214569
##	Luciano Gabriel Tonlorenzi Sebastía 39244171
##	Micaela Rocío De Rito 39547209 
##
##               Fecha de entrega: 14/06/2017
##
##
*/

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
 pid_t pid, pid1,pid2;
 int x,y;
 printf("Soy el proceso con PID %d\n",getpid());
 pid1 = getpid();
 for(x=1;x<=2;x++)
 {
  pid=fork();
  if(pid)
  {
   wait();
  }
  else
  {
   printf("soy el proceso con PID %d, hijo del proceso con PID %d\n",getpid(),getppid());

   if(x==1)
   {
    pid2 = getpid();
    for(y=1;y<=2;y++)
    {
     pid=fork();
      if(pid)
      {
       wait();
      }
      else
      {
       printf("soy el proceso con PID %d, hijo del proceso con PID %d, nieto del proceso con PID %d\n",getpid(),getppid(), pid1);
       if(y == 2)
       {
            pid=fork();
            if(pid)
                wait();
            else
            {
                printf("soy el proceso con PID %d, hijo del proceso con PID %d, nieto del proceso con PID %d, bisnieto del proceso con PID %d\n",getpid(),getppid(),pid2, pid1);
                exit(0);
            }
       }
       exit(0);
      }
    }
   }
   else
   {
    pid=fork();
    if(pid)
        wait();
    else
    {
        printf("soy el proceso con PID %d, hijo del proceso con PID %d, nieto del proceso con PID %d\n",getpid(),getppid(), pid1);
        exit(0);
    }
   }
   exit(0);
  }

 }
 return 0;
}
