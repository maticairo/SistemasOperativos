#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <fcntl.h>

#define TRUE 12


int main(){

	struct sockaddr_in server_addr;
	int sock, port,msg_sock, n;
	size_t bytes_read = 0;
	pid_t child;
	char buffer[1024], path[100];
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
		child = fork();
		
		if (!child){
		close(sock);
		puts("se ha conectado un cliente"); 
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
			close(msg_sock);
			exit(4);
		}
		send(msg_sock,"ok",2,0);
		puts("guardando archivo..");
		do{			
		n = read(msg_sock,buffer,sizeof(buffer));
		
		if (n < 0){
			close(fw);
			close(msg_sock);
			perror("read");
			exit(5);	
		}
		
		if(write(fw,buffer,n)<0){
			close(fw);
			close(msg_sock);	
			perror("write");
			exit(6);
		}
		bytes_read += n;
		}while(n > 0);
		printf("se han guardado %d bytes\n",bytes_read);
		close(msg_sock);
		close(fw);
		exit(0);
		}		  
		close(msg_sock);
		close(fw);
	} 
	close(sock);
	return(0);
}

