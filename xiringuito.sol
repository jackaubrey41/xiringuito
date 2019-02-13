pragma solidity ^0.4.25;

import "./XVOTE_ERC20.sol";
import "./XMONEY_ERC20.sol";


contract Xiringuito {

    struct Proposal {
        string description;
        bool open;
        uint voteCount;
        mapping(address => bool) votedAlready;
    }
    
    Proposal[] public proposals;                    // array con las propuesats a votar
    address public manager;
    
   // constante minimumContribution a 0.01 Ether require
   
    struct Soci {
        string _name;
        string email;
        string pasword;
        string dateRegister;
    }
    
    Soci [] public soci;                        // array con los socios que han realziado el contribute 
    mapping(address => soci) public mapSocis;   // Mapping de la dirección de los socios
    
    
    address public xmoney;
    address public vmoney;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor ( address barOwner) public {     // @xiringuito tiene los 100M de los dos tokens
        manager = barOwner;                      // el creador del contrato queda como manager por defecto
        xmoney = new XMONEY_ERC20;
        xvote = new XVOTE_ERC20;
    }


    function contribute() public payable {
        require(msg.value > 0.01 ether); // contribución minima correspondiente a un token
        require(ERC20Interface(xmoney).totalSupply() > 0, "We not can accept more investors");
        require(ERC20Interface(vmoney).totalSupply() > 0, "We not can accept more investors");
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
            open: false,
            voteCount: 0
        });

        proposal.push(newProposal); // Introducimos una nueva propuesta en el array de propuestas.
    }

    function voteProposal (uint index) public {                     //debemos indicar la propuesta a votar
        Proposal storage proposal = proposals[index];
        require (proposal.open = true);                             // requiere que la propuesta esté abierta
        require(ERC20Interface(xvote).balanceOf(msg.sender)>0);     // requiere que el votante tenga votos en su saldo
        require(!proposal.votedAlready[msg.sender]);                // requiere que no haya votado antes

        proposal.votedAlready[msg.sender] = true;           // unicamente puede votar una vez la prouesta
        proposal.voteCount += ERC20Interface(xvote).balanceOf(msg.sender);
    }

    function closePropousal(uint index) public restricted {
        Proposal storage proposal = proposals[index];
        proposal.open = false;                                      //cerramos la propuesta
    }

  