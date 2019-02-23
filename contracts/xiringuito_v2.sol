pragma solidity ^0.4.25;

import "./VotoXiringuito_ERC20_v2.sol";

contract Xiringuito {

    struct Proposal {
        string description;
        bool open;
        uint voteCount;
        mapping(address => bool) votedAlready;
    }
    
    struct Soci {
        string nameSoci;
    }
     
    Proposal[] public proposals;
    address public manager;
    mapping(address => Soci) public mapSocis;// Mapping de socios, puede ser tan completo como consideremos necesario. Cuidado con la LGPD.
    address public MoneyXiringuitoToken;
    address public VotoXiringuitoToken;

    modifier restricted() {
        require(msg.sender == manager, "el deployador del contrato es el manager que crea y finaliza propuestas");
        _; // añadir require de disponer de tokens en el smart contract
    }

// introducir factory y proxy 
    constructor ( address creator) public { 
        manager = creator;                          // El creador del contrato es el manager.
        MoneyXiringuitoToken = new XiringuitoToken_ERC20 ("XMONEY", "XiringuitoMoney");
        VotoXiringuitoToken = new XiringuitoToken_ERC20 ("XVOTE","XiringuitoVoto");
    }


    function contribute(string _nameSoci) public payable {
        require(msg.value > 0.01 ether, "debe invertir 0.01 Ether minimo"); // contribución minima correspondiente a un token
    
        uint numberTokens = (msg.value * 100 / 10**18);                         
        ERC20Interface(MoneyXiringuitoToken).transfer(msg.sender, numberTokens); // por cada ether le damos 100 tokens.
        ERC20Interface(VotoXiringuitoToken).transfer(msg.sender, numberTokens); // por cada ether le damos 100 tokens.

        Soci memory newSoci = Soci ({                   // Creamos un nuevo socio
            nameSoci: _nameSoci
        });
        mapSocis[msg.sender] = newSoci;                  // anotamos datos del nuevo socio en el Mapping
    }

    function createProposal (string description) public restricted {
        Proposal memory newProposal = Proposal({
            description: description,
            open: true,
            voteCount: 0                            
        });

        proposals.push(newProposal);                // Introducimos una nueva propuesta en el array de propuestas.
    }

    function voteProposal (uint index) public {             //debemos indicar el indice de la propuesta a votar
        Proposal storage proposal = proposals[index];

        require(ERC20Interface(VotoXiringuitoToken).balanceOf(msg.sender) > 0, "debemos tener tokens de voto");
        require(!proposal.votedAlready[msg.sender], "el socio no debe haber votado anteriormente esta propuesta"); // y que no haya votado antes
        require(proposal.open, "la propuesta debe estar abierta para poder votar");  // tenemos que comprobar que la propuesta este abierta
        proposal.votedAlready[msg.sender] = true;                                         // anotamos que ya ha votado. 
        proposal.voteCount += ERC20Interface(VotoXiringuitoToken).balanceOf(msg.sender); // anotamos un voto por token en el saldo del votante
    }

    function finalizeProposal(uint index) public restricted {
        Proposal storage proposal = proposals[index];
        proposal.open = false;
    }

//  Consulta de votos obtenidos por la propuesta
    function getVotesPropousalCount( uint index) public view returns (uint) {
        Proposal memory proposal = proposals[index];
        return proposal.voteCount;
    }

//  Consulta de número de propuestas
    function getProposalsCount() public view returns (uint) {
        return proposals.length;
    }

//  Permite al manager transferir Money Xiringuito tokens a un destinatario
//  Función que utilizaremos desde el manager para gestionar un pago con targeta de crédito
    function trasnferMoneyXiringuitoToken ( address destino, uint tokensTransferir) public restricted  {
        ERC20Interface(MoneyXiringuitoToken).transfer(destino,tokensTransferir);
    }
    
    function autoricePayment (address autorized, uint importe) public  {
        ERC20Interface(MoneyXiringuitoToken).approve(autorized, importe);
    }
    
//  Función de pago restringida al manager del negocio o al propietario de los tokens.  
// contable always manager
    function payMoneyXiringuito (address cliente, uint importeFactura) public {
        require(cliente == msg.sender || msg.sender == manager, "unicamente el manager o el usuario puede retirar tokens de la cuenta");
        ERC20Interface(MoneyXiringuitoToken).transferFrom(cliente,manager,importeFactura);
    }
    
    function getSaldoTokens (address wallet) public view returns (uint,uint) {
        return (
        ERC20Interface(MoneyXiringuitoToken).balanceOf(wallet),
        ERC20Interface(VotoXiringuitoToken).balanceOf(wallet)
        );
    }
}
