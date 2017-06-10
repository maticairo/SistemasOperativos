#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <pthread.h>
#include <fcntl.h>

#define PORT 5000
#define TRUE 12
#define DIR "/home/pjavalo/prueba/ppi.c"


int main(){

	struct sockaddr_in server_addr;
	int sock, port,msg_sock, n;
	size_t bytes_read;
	char buffer[1024], path[100];
	pthread_t tid;
	FILE * fw;

	puts("ingrese el puerto al que se desea conectar");

	scanf("%d",&port);

	memset(&server_addr,0,sizeof(server_addr));
	bzero(buffer, sizeof(buffer));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr  =htonl(INADDR_ANY);
	server_addr.sin_port =htons(port);

	sock = socket(AF_INET,SOCK_STREAM,0);

	 if (sock < 0) {
		  perror("opening stream socket");
		  exit(1);
	     }
	puts("socket creado");
	if (bind(sock,(struct sockaddr*)&server_addr,sizeof(server_addr))){
		perror("binding stream socket");
		exit(1);
	}
	puts("binded");
	listen(sock,10);
	puts("esperando por clientes");
	while(TRUE)
	{ 	
		msg_sock = accept(sock, 0, 0); 
		if (msg_sock == -1)
		{ 
			perror("accept");
			exit(1);
		}
		n=recv(msg_sock,path,sizeof(path),0);
		fprintf(stdout,"se creara archivo %s \n",path);
		fw = open(path, O_CREAT|O_WRONLY,0777);
		if (fw < 0){
			perror("abriendo file");
			send(msg_sock,"error",5,0);
			exit(4);
		}
		send(msg_sock,"ok",2,0);
		do{			
		n = read(msg_sock,buffer,1024);
		
		if (n < 0)
			perror("read");
		
		
		
		if(write(fw,buffer,n)<0)
			perror("write");
		}while(n > 0);		  
		close(msg_sock);
		close(fw);
	} 
		close(sock);
}

