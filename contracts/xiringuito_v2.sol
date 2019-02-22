pragma solidity ^0.4.25;

import "./VotoXiringuito_ERC20_v2.sol";

contract Xiringuito {

    struct Proposal {
        string description;
        bool open;
        uint voteCount;
        mapping(address => bool) votedAlready;
    }
    
    Proposal[] public proposals;
    address public manager;
    
   // constante minimumContribution a 0.01 Ether require
   
    struct Soci {
        string name;
//      string email;
    }
    
    Soci[] public socis; // un array??
    mapping(address => Soci) public mapSocis;// Mapping?
    
    address public MoneyXiringuitoToken;
    address public VotoXiringuitoToken;

    modifier restricted() {
        require(msg.sender == manager, "el deployador del contrato es el manager que crea y finaliza propuestas");
        _;
    }

    constructor ( address creator) public { 
        manager = creator;                          // El creador del contrato es el manager.
        MoneyXiringuitoToken = new XiringuitoToken_ERC20 ("XMONEY", "XiringuitoMoney");
        VotoXiringuitoToken = new XiringuitoToken_ERC20 ("XVOTE","XiringuitoVoto");
    }


    function contribute(/*string _name*/) public payable {
        require(msg.value > 0.01 ether, "debe invertir 0.01 Ether minimo"); // contribución minima correspondiente a un token

        ERC20Interface(MoneyXiringuitoToken).transfer(msg.sender, uint(msg.value*100)); // por cada ether le damos 100 tokens.
        ERC20Interface(VotoXiringuitoToken).transfer(msg.sender, uint(msg.value*100)); // por cada ether le damos 100 tokens.
  /*      
        // creamos un nuevo socio
        Soci memory newSoci = Soci ({
            name: _name
        });
        socis.push(newSoci);
        */
    }

    function createProposal (string description) public restricted {
        Proposal memory newProposal = Proposal({
            description: description,
            open: true,
            voteCount: 0                            // NO ha sido votada
        });

        proposals.push(newProposal);                // Introducimos una nueva propuesta en el array de propuestas.
    }

    function voteProposal (uint index) public {             //debemos indicar el indice de la propuesta a votar
        Proposal storage proposal = proposals[index];

        require(ERC20Interface(VotoXiringuitoToken).balanceOf(msg.sender) > 0, "debemos tener tokens de voto");
        require(!proposal.votedAlready[msg.sender], " no debe haber votado");                // y que no haya votado antes
        // tenemos que comprobar que la propuestab este abierta
        proposal.votedAlready[msg.sender] = true;                            // anotamos que ya ha votado. 
        proposal.voteCount += ERC20Interface(VotoXiringuitoToken).balanceOf(msg.sender); // anotamos un voto por token en el saldo del votante
    }

    function finalizeProposal(uint index) public restricted {
        Proposal storage proposal = proposals[index];
        proposal.open = false;
    }

    function getVotesPropousalCount( uint index) public view returns (uint) {
        Proposal memory proposal = proposals[index];
        return proposal.voteCount;
    }
   
    function getProposalsCount() public view returns (uint) {
        return proposals.length;
    }
    
    function trasnferMyTokens ( address destino, uint tokensTransferir) public restricted  {
        ERC20Interface(MoneyXiringuitoToken).transfer(destino,tokensTransferir);
    }
    
    function autoricePayment (address autorized, uint importe) public  {
        ERC20Interface(MoneyXiringuitoToken).approve( autorized, importe);
    }
    
    function payMoneyXiringuito (address cliente, address contable, uint importeFactura) public restricted {
        ERC20Interface(MoneyXiringuitoToken).transferFrom(cliente,contable,importeFactura);
    }
    
    function getSaldoTokens (address wallet) public view returns (uint,uint) {
        return (
        ERC20Interface(MoneyXiringuitoToken).balanceOf(wallet),
        ERC20Interface(VotoXiringuitoToken).balanceOf(wallet)
        );
    }
}


