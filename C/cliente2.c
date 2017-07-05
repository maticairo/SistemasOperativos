#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <string.h>
#include <sys/types.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <fcntl.h>

#define PORT 5000

#define MAX_BUF 1024

int main( int argc, char *argv[]){

struct sockaddr_in  cliente_addr;
char buffer[MAX_BUF],confirmacion[5], path [100], destino[100];
int sock,port,bytes,n;
size_t bs = 0;
FILE *fd;

memset(buffer,0,sizeof(buffer));
memset(&cliente_addr,0,sizeof(cliente_addr));

cliente_addr.sin_family = AF_INET;
cliente_addr.sin_addr.s_addr  =htonl(INADDR_ANY);
cliente_addr.sin_port =htons(port);
sock = socket(AF_INET,SOCK_STREAM,0);
if(sock < 0 ){
	perror("creating sock");
	exit(1);
}
puts("socket creado");

if ( inet_pton(AF_INET, argv[2], &(cliente_addr.sin_addr)) < 1 )
{
printf("IP invalida\n");
exit(1);
}

cliente_addr.sin_port = (argc > 3) ? htons(atoi(argv[3])) : htons(PORT);


if (connect(sock,(struct sockaddr*)&cliente_addr,sizeof(cliente_addr))<0){
	perror("no se pudo conectar con el servidor");
	close(sock);
	exit(2);
}	
fprintf(stdout,"se ha establecido la conexion con el servidor\n");


if((fd = open (argv[1],O_RDONLY , 0777)) < 0)
{
	perror("leyendo FILE");
	close(sock);
	exit(2);
}


puts("ingrese la ruta de destino");
scanf("%s",destino);

send(sock,destino,sizeof(destino),0);

n=recv(sock,confirmacion,sizeof(confirmacion),0);
confirmacion[n] = '\0';

if(strcmp(confirmacion,"ok") == 0){
	puts("iniciando transferencia");
}
else
{
	puts("no se pudo iniciar transferencia");
	close(sock);
	close(fd);
	exit(1);

}

while(1){
bytes = read(fd,buffer,sizeof(buffer));
bs += bytes;
if (bytes < 0 ){
		perror("error leyendo el archivo");
		close(fd);
		close(sock);
		exit(1);
}
if( bytes == 0)
	break;
if(write(sock,buffer,bytes)<0){
		
		perror("error enviando archivo");
		close(fd);
		close(sock);
		exit(1);
}

}
puts("finalizo la transferencia");
printf("%d bytes enviados\n",bs);
close(fd);


}
