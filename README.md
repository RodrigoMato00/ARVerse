# ARVerse
## Hackaton-BlockChain

26 de mayo de 2022
### RESUMEN
ARVerse: Es una plataforma en la que le podes dar un uso real a tus NFTs. Nuestros NFTS cuenta en su metadata con coordenadas geográficas de lugares específicos con alta concurrencia de público, ejemplo plazas, parques, estadios, mercados. A través del uso de Realidad aumentada web se podrá ver cualquier tipo de contenido en esas localizaciones (objetos 3d, vídeos, fotos,etc), para visualizar contenido solamente se deberá acceder a un URL desde cualquier dispositivo que cuente con un navegador y cámara.
El dueño del NFT podrá tanto venderlo como alquilarlo, algunos de nuestros NFTs también están  fraccionando como por ejemplo los NFTs que pertenecen a estadios, dando la posibilidad de ganar una doble renta.

### MIEMBROS DEL EQUIPO
  - Marcelo Arbiza - Project Manager - Blockchain - Backend
  - Rodrigo Mato- Blockchain - Backend - AR Specialist
  - Martin Casamayou - Blockchain - Frontend - Backend
  - Diego Guarise - Frontend
  - German Cavani- Frontend

### METAS

1-Diseño y creacion de Contratos NFTs y Marketplace
		-Contrato NFTs: ERC721 /ERC1115
		Funcions: Mint only owner y todas las funcionalidades que le corresponden
		al ERC 721.
2-Contrato Marketplace: ERC721
	Funciones: Mapping, nos devuelve una lista de items disponibles tanto en alquiler
		como venta, Add listing, permite al dueño del NFT añadirlo a la lista tanto
		vendiendo como alquilando y sus respectivos valores, al añadirse a la lista
		el NFT es transferido al contrato del Marketplace;
		Remuve listing; esta función permite al dueño del NFT quitarlo de la lista.
		Buy, permite a cualquier persona comprar un item de la lista; RentOut, permite
		que cualquier persona pueda rentar un NFT; FinishRenting, esta función hace
		que el NFT vuelva a su dueño, el inquilino puede ejecutarla en cualquier
		momento, y cualquier usuario de la blokchain puede ejecutarla luego de expirado
		el tiempo de renta*1; luego el contrato cuenta con varias funciones extras para
		obtener información sobre los ítems ofrecidos.

3- Conectar contratos : El contrato ERC721  cuenta con la funcionalidad de poder dar permiso de ejecución de sus funciones propias a otra dirección (setApprobalforall)*2.
4- Creación de nuestro propio Marketplace: aquí se listaran los NFTS disponibles y dará la posibilidad de comprar o rentar.
5- Conexión del Marketplace a la wallet utilizando web3.js(librería de jvascript).
6- Subasta: a  futuro planeamos que la persona que alquila ese NFT pueda subastar en determinados horarios donde se den de eventos puntuales como un partido de fútbol, dando la posibilidad a un anunciante de mostrar su publicidad. Para realizar la subata debemos fraccionar las partes alquiladas.
7- Metadata del NFT: la metadata del NFT estara alojada en una base de datos descentralizada utilizando Pinata. esto no binda la seguridad de lapermanecia de los datos, ya que si estuviece enun servidor este podria caer, probocando la perdida de los mismos. en el momento no se encuntra implmenteda aunque si fue testeado correctamnte para poder levantar los datos del AR geolocalizado. 
8- Proyección de AR geolocalizado:  para esto utilizamos Javascript y dos librerías AR.js y Aframe, los NFTs cuentan en su metadata con coordenadas GPS(latitud y longitud), los usuarios podrán acceder a ver la misma a través de su navegador web.

### ACLARACIONES

*1*2Renta: cuando el dueño de un token lo publica en el market especificando los valores de renta y venta le otorga privilegios al marketplace para ejecutar las funciones del contrato mismo ERC721, para que al momento de la venta del NFT el market pueda hacer la transferencia sin la aprobación del dueño. Al transferirse el token del mercado a otro usuario la los permisos que tiene el mercado sobre el NFT se revocan por defecto. Esto no tiene nada de malo si la transacción se trata de una venta, pero al momento del alquiler esto trae varios problemas.
En un contrato sin utilizar como intermediario el marketplace esta función trabaja de manera normal permitiendo rentar  y devolver el NFT a su dueño una vez finalizado o pasado el tiempo de renta. Con el Marketplace como intermediario esto cambia y genera problemas no dejando ejecutar la función de Finishrenting para devolver el NFT, esto se debe a que en la transferencia (_transfer) el Market pierde todo privilegio sobre el NFT; para intentar solucionar esto reescribimos la función _transfer del contrato el token ERC721 “_approved(addres(0), tokenId);”
intentamos comentar la línea anteriormente mencionada para que se mantuvieran los permisos, (teniendo en cuenta que esto deja al dueño anterior con permisos) pero nunca pudimos terminar de compilar el contrato ya que nos daba un error, la función añadir ítem a al marketplace pedía que fuese payable por más que en ningún momento ni la función ni ningún proceso llamado detrás de la misma necesitaba hacer algún tipo transferencia de dinero.
También intentamos implementar un wrapper ERC20 pero fue en las versiones anteriores al contrato del marketplace.

### Infraestructura de Contratos:

![Text](/images/diagrama.jpeg)

### Ejemplo de Realidad Aumentada:

#### Escanear codigo QR.
[Link-AR](https://rodrigomato00.github.io/A-Frame_exercises/3-Crear_escena/escena.html)

![Text](/images/AR-Example-web.png)

#### Luego de abir la web, e inicializar la camara enfocar el siguiente patron.

![Text](/images/pattern-kanji.png)
