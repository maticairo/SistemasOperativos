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

int main(){

struct sockaddr_in  cliente_addr;
char buffer[MAX_BUF],confirmacion[5], path [100], destino[100];
int sock,port,bytes,n;
size_t bs = 0;

FILE *fd;
puts("ingrese el puerto al que se desea conectar");
scanf("%d",&port);


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

inet_pton(AF_INET,"192.168.42.213",&cliente_addr.sin_addr);
if (connect(sock,(struct sockaddr*)&cliente_addr,sizeof(cliente_addr))<0){
	perror("no se pudo conectar con el servidor");
	close(sock);
	exit(2);
}	
fprintf(stdout,"se ha establecido la conexion con el servidor\n");

puts("ingrese la ruta del archivo que desea enviar");

scanf("%s",path);


fd = open (path,O_RDONLY , 0777);
if(fd < 0){
  perror("abriendo file");
  close(sock);
  exit(1);
}

puts("ingrese la ruta de destino");
scanf("%s",destino);
send(sock,destino,sizeof(destino),0);

n=recv(sock,confirmacion,sizeof(confirmacion),0);
confirmacion[n] = '\0';
if(strcmp(confirmacion,"error") == 0){
	puts("no se pudo iniciar transferencia");
	close(sock);
	close(fd);
	exit(1);
}

if(strcmp(confirmacion,"ok") == 0){
	puts("iniciando transferencia");
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
