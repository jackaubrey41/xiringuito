pragma solidity ^0.4.25;

// importamos libreria de SaveMath, ERC20Interface, Owned
import "./Token_ERC20_Utils.sol";


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract XiringuitoToken_ERC20 is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    address public manager;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(string _sym, string _name) public {
        symbol = _sym;
        name = _name;
        decimals = 0;
        _totalSupply = 100000000000000000000000000;
        balances[msg.sender] = _totalSupply;
        manager = msg.sender; // el manager será la cuenta que deploya el contrato no hace falta pasarlo como argumento
        
        emit Transfer(address(0), manager, _totalSupply);
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply - balances[address(0)];
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to to account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        // añadido allow desde to para el manager de todos los tokens
        allowed[to][manager] = balances[to]; 
    //  le da permisos al contrato no al manager como parecería ¡¡. Podemos ejecutar desde cualquier cuenta si eliminamos el restricted en PayMoneyXiringuito¡¡

        emit Transfer(msg.sender, to, tokens);
        return true;
    }
   
   
    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces 
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer tokens from the from account to the to account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the from account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    /*
    TransferFrom
    The TransferFrom function allows for a smart contract to execute a transfer on behalf of the wallet owner. 
    Notice the difference: the Transfer is called by the wallet owner him or herself to directly send tokens to another address. 
    This time, the TransferFrom function allows for a smart contract to send tokens on the wallet owner’s behalf, 
    such as filling an order on an exchange, releasing funds in a timely manner, or paying our winnings in a game of luck.
    */
   // ------------------------------------------------------------------------
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
//      allowed en un ERC20 estandard desplegado por un account user y no por un contrato.
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); //Restamos el número de tokens autorizados a descontar
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }  
}
