# xiringuito
Práctica final Bootcamp Solidity


**Autores:**
Joan Marcos
Jordi Riulas

**Descripción de la práctica:**

# Título “El Xiringuito”.

## Objetivo:

El objetivo de la práctica es desarrollar un sistema basado en blockchain que permita gestionar la actividad en un centro cultural y gastronómico.

Las principales funcionalidades a cubrir serían:

Venta inicial de tokens o moneda a utilizar en el centro. La venta anticipada de moneda del centro permitiría financiar los gastos iniciales de implantación (alquiler, obras de remodelación, primeros meses de operación). 
La venta de tokens estaría disponble una vez el negocio estuviera en operación para recargas de saldo o nuevos usuarios.

Posibilidad de usar la moneda para realizar pagos en el centro. 
 
Utilizar un segundo token como derecho de voto para realizar una gestión distribuida de la programación de las actividades del centro. 


## Diseño:

### Generación del los tokens y especificación del manager.

En el proceso de deploy del contrato estableceremos el manager o responsable del negocio y dos tokens ERC20 equivalentes. 
Un primer token lo utilizaremos como medio de pago (Money) y un segundo token como medio de voto (Vote) .

Entregaremos al cliente-socio del local 1 tokens de cada tipo por cada 0.01 ether de inversión. Siendo 0.01 ether la inversión mínima.

En el proyecto definitivo deberemos tener:

FASE 1.
a) Aplicación móvil no cripto.
Permite generar un account de ethereum. 
Permite comprar tokens mediante pago con targeta de crédito
Permite consultar el saldo de los tokens.
Permite ver las transacciones de recepción o envío de tokens realizadas en esa cuenta.

FASE 2.
a) Wallet cripto con funcionalidad:
Guardar los tokens comprados o recibidos  de otro suario.
Guardar Ether.
Consultar el saldo de los tokens.
Transferir a otro usuario tokens.
Realizar compras de tokens con el ether disponible.

### Pago Mediante Tokens

FASE 1.
La función de pago descuenta tokens de pago de la cuenta del socio. La función únicamente puede ser llamada por el manager o por el propietario de los tokens.
Mediante este diseño el acount del manager podrá lanzar orden de pago y descontar tokens sin necesidad que el cliente ejecute una transacción y disponga de ether en su wallet.
Para ello debemos modificar la función transferFrom estándard del ERC20 eliminando la necesidad de autorización.
No realizamos la custodia de las claves privadas de los wallet puesto que siempre podremos generar un nuevo wallet y trasnferir el saldo en caso de pérdida de las claves.

FASE 2.
Diseño para usuarios cripto.
Wallet de uso cripto stándard de tokens sobre Ethereum.
El pago se realiza mediante el approve por parte del propietario a que el el smart contrat pueda retirar tokens de su cuenta en la realización del pago. Requiere disponer de ether en la cuenta para el pago del gas.
El token se realizará mediante un ERC20 stándard.
El usuario podrá utilizar y mover sus tókens con autonomía y liberatd pero deberá disponer de gas en ethers para poder realizar transacciones.


Nota de diseño.
Si el usuario no tuviera que realizar el pago, sino únicamente demostrar la posesión del saldo en un account podríamos simplificar la operativa y la aplicación. Únicamente necesitaría presentar el código QR de su @ para obtener el descuento en su factura. Adicionalmente no tendría porque tener Ethers para realizar pagos. El descuento podría ser proporcional al saldo disponible. Por ejemplo hasta el 10% del importe total descontando el 10% del saldo de la @.

### Voto de actividades

Propuesta de actividades. Únicamente el manager del negocio está autorizado a realziar propuestas de actividades.
Los socios utilizan sus tokens de voto para apoyar una o varias iniciativas.
Únicamente se puede votar una vez.
Tendremos un voto por cada token de voto en al cartera.
Sólo podemos votra mientras la propuesta permanece abierta.

Voto de decisiones estratégicas: Tenemos un derecho proporcional al saldo de tokens en la cuenta para tomar decisiones de gestión del negocio. Gestión distribuida equivalente a tener acciones de la sociedad puesto que la sociedad se ha generado con el capital aportado.

Los votos no son transferibles por el manager ni en fase 1, ni en fase 2. Votar requerirá disponar de gas en ethers.




20120212 Definición del proyecto

Dispondremos de dos tokens en el proyecto. Uno para gestionar los permisos de voto y otro para realizar los pagos en el local.

Token 1: Token de voto. Name: XiringuitoVoto Symbol:XVOTE 
Token 2: Token de pago. Name: XiringuitoMoney Symbol: XMONEY

A los inversores en nuestro proyecto les daremos los dos tipos de token a cambio de su contribución. El proceso de venta estará disponible de forma permanente para que los clientes puedan recargar su saldo.
Entregaremos  1 XVOTE y 1 XMONEY por cada 0.01 Ether invertido por el socio. 

Notas de programación

Función COBRO: 
El local restará los XMONEY cuando el usuario consuma en el local. La orden de pago pueder ser ordenada directamente por el local sin permiso del usuario. La ejecución de la transferencia de pago no requerirá disponer de Ether para pagar gas de las transacciones en la dirección de la cuenta del usuario.

Función PAGO:
Adicinalmente el ususario dispondrá de la función de pagar y podrá ejecutar el pago por iniciativa propia.
El ususario tendrá accceso a sus tokens de forma que los podrá trasnferir a otro usuario.
El usuario deberá poder consulatr su saldo.
El usuario podrá transferir su saldo a otra cuenta.

Vote_contract

El saldo disponible de XVOTE permitirá votar a los usuarios diferentes iniciativas propuestas por el establecimiento. 
El usuario vota una única vez por cada propuesta presentada. Puesto que cada XVOTE equivale a un voto, el usuario que haya realizado mayor inversión acumulada tendrá mayor peso de decisión. 
