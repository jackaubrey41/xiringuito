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
        string _name;
        string email;
        string pasword;
        string dateRegister;
    }
    
    Soci[] public soci; // un array??
    mapping(address => Soci) public mapSocis;// Mapping?
    
//    address public MoneyXiringuitoToken;
    address public VotoXiringuitoToken;

    modifier restricted() {
        require(msg.sender == manager, "el deployador del contrato es el manager que crea y finaliza propuestas");
        _;
    }

    constructor ( address creator) public { 
        manager = creator;                          // El creador del contrato es el manager.
//        MoneyXiringuitoToken = new XiringuitoToken_ERC20 ("XMONEY", "XiringuitoMoney");
        VotoXiringuitoToken = new XiringuitoToken_ERC20 ("XVOTE","XiringuitoVoto");
    }


    function contribute() public payable {
        require(msg.value > 0.01 ether, "debe invertir 0.01 Ether minimo"); // contribución minima correspondiente a un token

//        ERC20Interface(MoneyXiringuitoToken).transfer(msg.sender, uint(msg.value*100)); // por cada ether le damos 100 tokens.
        ERC20Interface(VotoXiringuitoToken).transfer(msg.sender, uint(msg.value*100)); // por cada ether le damos 100 tokens.
        //Falta anotar los datos del socio
        
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
        require(!proposal.votedAlready[msg.sender], " no debe ahaber votado");                // y que no haya votado antes
        
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
    
}