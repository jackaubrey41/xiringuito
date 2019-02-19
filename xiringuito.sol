pragma solidity ^0.4.25;

import "./XVOTE_ERC20.sol";
//import "./XMONEY_ERC20.sol"; // Da error de duplicado de declaración de funciones.


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
    
    
    address public xmoney; // debemos declarar la variable tipo @ del token
    address public xvote;

    modifier restricted() {
        require(msg.sender == manager, "el deployador es el manager");
        _;
    }

    constructor ( address creator) public { // @xiringuito tendrria los 100M de los dos tokens
        manager = creator;
//        xmoney = new XMONEY_ERC20 ();
        xvote = new XVOTE_ERC20 ();
    }


    function contribute() public payable {
        require(msg.value > 0.01 ether, "debe invertir 0.01 Ether minimo"); // contribución minima correspondiente a un token
//        require(ERC20Interface(xmoney).totalSupply() > 0, "We not can accept more investors");
        require(ERC20Interface(xvote).totalSupply() > 0, "We not can accept more investors");
//        require(ERC20Interface(token).totalSupply() > uint(msg.value/minimumContribution), "We not have token for this investor");
        
        
//       approvers[msg.sender] = true;
//        approversCount += uint(msg.value/minimumContribution);
        
//        ERC20Interface(xmoney).transfer(msg.sender, uint(msg.value/minimumContribution));
        ERC20Interface(xmoney).transfer(msg.sender, uint(msg.value*100)); // por cada ether le damos 100 tokens.
        ERC20Interface(xvote).transfer(msg.sender, uint(msg.value*100)); // por cada ether le damos 100 tokens.
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

        require(ERC20Interface(xvote).balanceOf(msg.sender) > 0, "debemos tener tokens de voto");
        require(!proposal.votedAlready[msg.sender], " no debe ahaber votado");                // y que no haya votado antes
        
        proposal.votedAlready[msg.sender] = true;                            // anotamos que ya ha votado. 
        proposal.voteCount += ERC20Interface(xvote).balanceOf(msg.sender); // anotamos un voto por token en el saldo del votante
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
