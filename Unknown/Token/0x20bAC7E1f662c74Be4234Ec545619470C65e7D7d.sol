['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20 {\n', '\t//Sets functions and events to comply with ERC20\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\tevent Transfer(address indexed _from, address indexed _to, uint _value);\n', '\t\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\tfunction approve(address _spender, uint _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '}\n', '\n', 'contract Owned {\n', '\t//Public variable\n', '    address public owner;\n', '\n', '\t//Sets contract creator as the owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\t\n', '\t//Sets onlyOwner modifier for specified functions\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '\t//Allows for transfer of contract ownership\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Token is ERC20, Owned {\n', '\t//Public variables\n', '\tstring public name; \n', '\tstring public symbol; \n', '\tuint8 public decimals; \n', '\tuint256 public totalSupply; \n', '\t\n', '\t//Creates arrays for balances\n', '    mapping (address => uint256) balance;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\t\n', '\tfunction Token(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 initialSupply) {\n', '\t\tname = tokenName; \n', '\t\tsymbol = tokenSymbol; \n', '\t\tdecimals = decimalUnits; \n', '\t\ttotalSupply = initialSupply; \n', '\t}\n', '\t\n', '\t//Provides the remaining balance of approved tokens from function approve \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\t//Allows for a certain amount of tokens to be spent on behalf of the account owner\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\t//Returns the account balance \n', '    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {\n', '        return balance[_owner];\n', '    }\n', '\n', '\t//Sends tokens from sender&#39;s account\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balance[msg.sender] >= _value && balance[_to] + _value > balance[_to]) {\n', '            balance[msg.sender] -= _value;\n', '            balance[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { \n', '\t\t\treturn false; \n', '\t\t}\n', '    }\n', '\t\n', '\t//Transfers tokens an approved account \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balance[_from] >= _value && allowed[_from][msg.sender] >= _value && balance[_to] + _value > balance[_to]) {\n', '            balance[_to] += _value;\n', '            balance[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { \n', '\t\t\treturn false; \n', '\t\t}\n', '    }\n', '}\n', '\n', 'contract Prether is Token {\n', '    //Public variables\n', '    string public constant name = "PRETHER";\n', '    string public constant symbol = "PTH"; \n', '    uint8 public constant decimals = 0; \n', '    uint256 public constant supply = 10000000; \n', '    \n', '\t//Initializes Prether as a Token\n', '\tfunction Prether()\n', '\t    Token(name, symbol, decimals, supply) {\n', '\t\t\tbalance[msg.sender] = supply;                                           \n', '    }\n', '\t\n', '\t//Prevents sending Ether to the contract\n', '\tfunction() {\n', '\t\tthrow; \n', '\t}\n', '\t\n', '\t//Allows contract owner to mint new tokens, prevents numerical overflow\n', '\tfunction mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {\n', '\t\tif ((totalSupply + mintedAmount) < totalSupply) {\n', '\t\t\tthrow; \n', '\t\t} else {\n', '\t\t\tbalance[target] += mintedAmount;\n', '\t\t\ttotalSupply += mintedAmount;\n', '\t\t\tTransfer(0, target, mintedAmount);\n', '\t\t\treturn true; \n', '\t\t}\n', '\t}\n', '}']