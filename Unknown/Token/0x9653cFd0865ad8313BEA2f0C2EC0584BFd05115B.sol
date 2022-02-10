['pragma solidity ^0.4.2;\n', '\n', 'contract ERC20Interface {\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract Owner {\n', '    //For storing the owner address\n', '    address public owner;\n', '\n', '    //Constructor for assign a address for owner property(It will be address who deploy the contract) \n', '    function Owner() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    //This is modifier (a special function) which will execute before the function execution on which it applied \n', '    modifier onlyOwner() {\n', '        if(msg.sender != owner) throw;\n', '        //This statement replace with the code of fucntion on which modifier is applied\n', '        _;\n', '    }\n', '    //Here is the example of modifier this function code replace _; statement of modifier \n', '    function transferOwnership(address new_owner) onlyOwner {\n', '        owner = new_owner;\n', '    }\n', '}\n', '\n', 'contract FuturXe is ERC20Interface,Owner {\n', '\n', '    //Common information about coin\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    //Balance property which should be always associate with an address\n', '    mapping(address => uint256) balances;\n', '    //frozenAccount property which should be associate with an address\n', '    mapping (address => bool) public frozenAccount;\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    //These generates a public event on the blockchain that will notify clients\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    //Construtor for initial supply (The address who deployed the contract will get it) and important information\n', '    function FuturXe(uint256 initial_supply, string _name, string _symbol, uint8 _decimal) {\n', '        balances[msg.sender]  = initial_supply;\n', '        name                  = _name;\n', '        symbol                = _symbol;\n', '        decimals              = _decimal;\n', '        totalSupply           = initial_supply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    //Function for transer the coin from one address to another\n', '    function transfer(address to, uint value) returns (bool success) {\n', '\n', '        //checking account is freeze or not\n', '        if (frozenAccount[msg.sender]) return false;\n', '\n', '        //checking the sender should have enough coins\n', '        if(balances[msg.sender] < value) return false;\n', '        //checking for overflows\n', '        if(balances[to] + value < balances[to]) return false;\n', '        \n', '        //substracting the sender balance\n', '        balances[msg.sender] -= value;\n', '        //adding the reciever balance\n', '        balances[to] += value;\n', '        \n', '        // Notify anyone listening that this transfer took place\n', '        Transfer(msg.sender, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    //Function for transer the coin from one address to another\n', '    function transferFrom(address from, address to, uint value) returns (bool success) {\n', '\n', '        //checking account is freeze or not\n', '        if (frozenAccount[msg.sender]) return false;\n', '\n', '        //checking the from should have enough coins\n', '        if(balances[from] < value) return false;\n', '\n', '        //checking for allowance\n', '        if( allowed[from][msg.sender] >= value ) return false;\n', '\n', '        //checking for overflows\n', '        if(balances[to] + value < balances[to]) return false;\n', '        \n', '        balances[from] -= value;\n', '        allowed[from][msg.sender] -= value;\n', '        balances[to] += value;\n', '        \n', '        // Notify anyone listening that this transfer took place\n', '        Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    //\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    //\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    //\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner{\n', '        balances[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        \n', '        Transfer(0,owner,mintedAmount);\n', '        Transfer(owner,target,mintedAmount);\n', '    }\n', '\n', '    //\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    //\n', '    function changeName(string _name) onlyOwner {\n', '        name = _name;\n', '    }\n', '\n', '    //\n', '    function changeSymbol(string _symbol) onlyOwner {\n', '        symbol = _symbol;\n', '    }\n', '\n', '    //\n', '    function changeDecimals(uint8 _decimals) onlyOwner {\n', '        decimals = _decimals;\n', '    }\n', '}']