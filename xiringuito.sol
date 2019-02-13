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
    
    Proposal[] public proposal;
    address public manager;
    
   // constante minimumContribution a 0.01 Ether require
   
    struct Soci {
        string _name
        string email
        string pasword
        string dateRegister
    }
    
    Soci [] public soci; // un array??
    mapping(address => soci) public mapSocis;// Mapping?
    
    
    address public xmoney;
    address public vmoney;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function createTokens ( address creator) public { // @xiringuito tendrria los 100M de los dos tokens
        manager = creator;
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
            open: false;
            voteCount: 0
        });

        proposal.push(newProposal); // Introducimos una nueva propuesta en el array de propuestas.
    }

    function voteProposal (uint index) public {             //debemos indicar la propuesta a votar
        Proposal storage proposal = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount += ERC20Interface(token).balanceOf(msg.sender);
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          minimumContribution,
          this.balance,
          requests.length,
          approversCount,
          manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}
