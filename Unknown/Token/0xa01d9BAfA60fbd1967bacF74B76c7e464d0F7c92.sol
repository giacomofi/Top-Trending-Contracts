['pragma solidity ^0.4.12;\n', '\n', 'contract ElevenOfTwelve {\n', '    \n', '    // totalSupply = Maximum is 210000 Coins with 18 decimals;\n', '    // Only 1/100 of the maximum bitcoin supply.\n', '    // Nur 1/100 vom maximalen Bitcoin Supply.\n', '    // ElevenOfTwelve IS A VERY SEXY COIN :-)\n', '    // Buy and get rich!\n', '\n', '    uint256 public totalSupply = 210000000000000000000000;\n', '    uint256 public availableSupply= 210000000000000000000000;\n', '    uint256 public circulatingSupply = 0;  \t\n', '    uint8   public decimals = 18;\n', '  \n', "    string  public standard = 'ERC20 Token';\n", "    string  public name = 'ElevenOfTwelve';\n", "    string  public symbol = '11of12';            \n", '    uint256 public crowdsalePrice = 100;                          \t\n', '    uint256 public crowdsaleClosed = 0;                 \n', '    address public daoMultisig = msg.sender;\n', '    address public owner = msg.sender;  \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\t\n', '\t\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);    \n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\t\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\t\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\t\n', '\t\n', '    function () payable {\n', '        if (crowdsaleClosed > 0) throw;\t\t\n', '        if (msg.value == 0) {\n', '          throw;\n', '        }\t\t\n', '        if (!daoMultisig.send(msg.value)) {\n', '          throw;\n', '        }\t\t\n', '        uint token = msg.value * crowdsalePrice;\t\t\n', '\t\tavailableSupply = totalSupply - circulatingSupply;\n', '        if (token > availableSupply) {\n', '          throw;\n', '        }\t\t\n', '        circulatingSupply += token;\n', '        balances[msg.sender] += token;\n', '    }\n', '\t\n', '    function setPrice(uint256 newSellPrice) onlyOwner {\n', '        crowdsalePrice = newSellPrice;\n', '    }\n', '\t\n', '    function stoppCrowdsale(uint256 newStoppSign) onlyOwner {\n', '        crowdsaleClosed = newStoppSign;\n', '    }\t\t\n', '\n', '    function setMultisigAddress(address newMultisig) onlyOwner {\n', '        daoMultisig = newMultisig;\n', '    }\t\n', '\t\n', '}']