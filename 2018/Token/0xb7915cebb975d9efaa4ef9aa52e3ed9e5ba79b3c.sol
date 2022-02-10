['pragma solidity ^0.4.25;\n', '\n', '\n', '//   token smart contract for trade nex\n', '\n', '//   This is a test contract for tradex coin\n', '//\t\tcode is written by Muyiwa O. Samson\n', '//\t\tcopy right : Muyiwa Samson\n', '//  \n', '//\n', '\n', 'contract Token {\n', '\n', '    ///CORE FUNCTIONS; these are standard functions that enables any token to function as a token\n', '    function totalSupply() constant returns (uint256 supply) {}\t\t\t\t\t\t\t\t\t\t/// this function calls the total token supply in the contract\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\t\t\t\t\t\t/// Function that is able to call all token balance of any specified contract address holding this token\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\t\t\t\t\t\t/// Function that enables token transfer\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}  \t/// Function that impliments the transfer of tokens by token holders to other ERC20 COMPLIENT WALLETS \n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\t/// Returns the values for token balances into contract record\n', '\n', '    \n', '\t//CONTRACT EVENTS\n', '\tevent Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        \n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        \n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract Tradenexi is StandardToken { \n', '\n', '   \n', '    string public name;                   // Token Name\n', '    uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18\n', '    string public symbol;                 // An identifier: eg SBX, XPR etc..\n', '    uint256 public exchangeRate;         // How many units of your coin can be bought by 1 ETH? unitsOneEthCanBuy now etherexchange\n', '    address public icoWallet;           // Where should the raised ETH go?\n', '\n', '    \n', '\n', '\taddress public creator;\n', '\t\n', '\tbool public isFunding;\n', '\n', '    // This is a constructor function \n', '    // which means the following function name has to match the contract name declared above\n', '    function Tradenexi() {\n', '        balances[msg.sender] = 1000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 1000000000000000000. (CHANGE THIS)\n', '        totalSupply = 1000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)\n', '        name = "Trade Nexi";                                   // Set the name for display purposes (CHANGE THIS)\n', '        decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)\n', '        symbol = "NEXI";                                             // Set the symbol for display purposes (CHANGE THIS)\n', '        icoWallet = msg.sender;                                    // The owner of the contract gets ETH\n', '\t\tcreator = msg.sender;\n', '    }\n', '\t\n', '\t  \n', '    function updateRate(uint256 _rate) external {\n', '        require(msg.sender==creator);\n', '        require(isFunding);\n', '        exchangeRate = _rate;\n', '\t\t\n', '\t}\n', '\t\n', '\t\n', '\tfunction ChangeicoWallet(address EthWallet) external {\n', '        require(msg.sender==creator);\n', '        icoWallet = EthWallet;\n', '\t\t\n', '\t}\n', '\tfunction changeCreator(address _creator) external {\n', '        require(msg.sender==creator);\n', '        creator = _creator;\n', '    }\n', '\t\t\n', '\n', '\tfunction openSale() external {\n', '\t\trequire(msg.sender==creator);\n', '\t\tisFunding = true;\n', '    }\n', '\t\n', '\tfunction closeSale() external {\n', '\t\trequire(msg.sender==creator);\n', '\t\tisFunding = false;\n', '    }\t\n', '\t\n', '\t\n', '\t\t\n', '    function() payable {\n', '        require(msg.value >= (1 ether/50));\n', '        require(isFunding);\n', '        uint256 amount = msg.value * exchangeRate;\n', '\t\t      \n', '        balances[icoWallet] = balances[icoWallet] - amount;\n', '        balances[msg.sender] = balances[msg.sender] + amount;\n', '\n', '        Transfer(icoWallet, msg.sender, amount); // Broadcast a message to the blockchain\n', '\n', '        //Transfer ether to fundsWallet\n', '        icoWallet.transfer(msg.value);                               \n', '    }\n', '\t\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']