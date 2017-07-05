#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <pthread.h>
#include <fcntl.h>

#define TRUE 12
#define PORT 5000



void* t_handler(void *);

int main( int argc, char *argv[] ){

	struct sockaddr_in server_addr;
	int sock,msg_sock;
	pthread_t tid; 
	
	

	memset(&server_addr,0,sizeof(server_addr));
	
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr  =htonl(INADDR_ANY);
	server_addr.sin_port = (argc > 1) ? htons(atoi(argv[1])) : htons(PORT);

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
	while(msg_sock = accept(sock, 0, 0))
	{ 	

		if( pthread_create( &tid , NULL , t_handler , (void*)&msg_sock) < 0)
		{
		    perror("no se pudo crear el thread");
		    return 1;

		}					  
		
		
	} 
	close(sock);
	return(0);
}

void* t_handler(void *socket){


		 FILE *fw;
		int msg_sock = *(int*)socket;
		char buffer[1024],path[200];
		size_t bytes_read;
		int n;		
		
		if (msg_sock == -1)
		{ 
			perror("accept");
			return 1;
		}
		puts("se ha conectado un cliente");
		n=recv(msg_sock,path,sizeof(path),0);
		fprintf(stdout,"se creara archivo %s \n",path);
		fw = open(path, O_CREAT|O_WRONLY,0777);
		if (fw < 0){
			perror("abriendo file");
			send(msg_sock,"error",5,0);
			close(msg_sock);
			return(4);
		}
		send(msg_sock,"ok",2,0);
		puts("guardando archivo..");
		bzero(buffer, sizeof(buffer));
		do{			
		n = read(msg_sock,buffer,sizeof(buffer));
		
		if (n < 0){
			close(fw);
			close(msg_sock);
			perror("leyendo archivo");
			return(5);	
		}
		
		if(write(fw,buffer,n)<0){
			close(fw);
			close(msg_sock);	
			perror("enviando archivo");
			return(6);
		}
		bytes_read += n;
		}while(n > 0);

		if(bytes_read > 0){
		printf("se han guardado %d bytes\n",bytes_read);
		}
		else {
		printf("Ocurrio un error al guardar el archivo\n");
		}		
		close(msg_sock);
		close(fw);
		return 0;
	
}
