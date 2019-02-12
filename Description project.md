Práctica final Bootcamp Solidity


Autores:
Joan Marcos
Jordi Riulas

Descripción de la práctica:

Título “El Xiringuito”.

Objetivo:

El objetivo de la práctica es desarrollar un sistema basado en blockchain que permita gestionar la actividad en un centro cultural y gastronómico.

Las principales funcionalidades a cubrir serían:

Venta inicial de tokens o moneda a utilizar en el centro para financiar los gastos iniciales de implantación: alquiler, obras de remodelación, primeros meses de operación.

Posibilidad de usar la moneda para realizar pagos en el centro, con descuento. Una posibilidad alternativa sería utilizar euros para el pago efectivo pero usar la moneda o token como un derecho o bono de descuento.
 
Utilizar el token como derecho de voto para realizar una gestión distribuida de la programación de las actividades del centro. 


Diseño:

FASE 1: Generación del token y venta

Deberemos generar un token o moneda basado en el estándar ERC20.
Debemos tener una interfaz web o formulario para la ejecución de la venta con las indicaciones al inversor.
Debemos preveer que el inversor pagará en Ethers o en FIAT.
Debemos proponer al usuario un entorno donde recibir sus tokens, preferiblemente en entorno mobile.
Debemos prever si realizamos la custodia de las claves privadas de los wallet para aquellos usuarios no cripto y ofrecemos un light wallet.

FASE 2: Uso del token en el Xiringuito.

Debemos pensar cuál será el mecanismo de uso de la moneda y de qué herramientas dispondrá el usuario para realizar los pagos. Desde la posibilidad de simplemente utilizar Metamask o My Etherwallet hasta la posibilidad de en un futuro implementar un wallet en móvil ( código open source BRD).

Si el usuario no tuviera que realizar el pago, sino únicamente demostrar la posesión del saldo en un account podríamos simplificar la operativa y la aplicación. Únicamente necesitaría presentar el código QR de su @ para obtener el descuento en su factura. Adicionalmente no tendría porque tener Ethers para realizar pagos. El descuento podría ser proporcional al saldo disponible. Por ejemplo hasta el 10% del importe total descontando el 10% del saldo de la @.

FASE 3:

Propuesta de actividades. Utilizar el saldo de la cuenta en tokens para permitir publicar actividades.
Voto de actividades: Tener derecho a un voto con un saldo mínimo de tokens para votar actividades.
Voto de decisiones estratégicas: Tener un derecho proporcional al saldo de tokens en la cuenta para tomar decisiones de gestión del negocio. Gestión distribuida equivalente a tener acciones de la sociedad.


20190206 Tutoria Comentarios Jesus:

Generar dos Tokens. Los dos Tokens se transmiten al inversor en la ICO.

Token a: Token de voto.
Token b: Token de pago.

Smart contract de gestion de voto. Generación de eventos y contabilidad del voto.
Smart contract de pago. El usuario presenta su @publica en una tarjeta de descuento el sistema le carga o le descuenta tokens en los eventos de pago y de recarga.

La transferencia de los tokens está limitada al manager y al owner.


20120212 Definición del proyecto

Dispondremos de dos tokens en el proyecto. Uno para gestionar los permisos de voto y otro para realizar los pagos en el local.

Token 1: Token de voto. Nombre XVOTE
Token 2: Token de pago. Nombre XMONEY

ICO_contract

Realizaremos un smartcontract encargado de gestionar el proceso de inversión y registro de los socios Nombre ICO_contract.
A los inversores en nuestro proyecto les daremos los dos tipos de token a cambio de su contribución. El smart contract estará disponible de forma permanente para que los clientes puedan recargar su saldo.
Entregaremos  1 XVOTE y 1 XMONEY por cada 0.01 Ether invertido por el socio. Adicionalmente les solicitaremos e-mail de contacto, nombre y apellidos. 
Añadiremos un función para poder actualizar el email, nombre o apellido de una determinada dirección de inversor.

Local_contract

Los XMONEY se consumiran a cambio de servicios.

Función COBRO: 
El local restará los XMONEY cuando el usuario consuma en el local. La orden de pago pueder ser ordenada directamente por el local. La ejecución de la transferencia de pago no requerira disponer de Ether para pagar en la cuenta del usuario.

Función PAGO: 
Adicinalmente el ususario dispondrá de la función de pagar y podrá ejecutar el apgo por iniciativa propia.
El ususario tendrá accceso a sus tokens de forma que los podrá trasnferir a otro usuario.
El usuario deberá poder consulatr su saldo.


