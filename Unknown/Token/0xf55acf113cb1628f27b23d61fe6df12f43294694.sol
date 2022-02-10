['pragma solidity ^0.4.14;\n', '\n', '/* &#169;RomanLanskoj 2017\n', 'I can create the cryptocurrency Ethereum-token for you, with any total or initial supply,  enable the owner to create new tokens or without it,  custom currency rates (can make the token&#39;s value be backed by ether (or other tokens) by creating a fund that automatically sells and buys them at market value) and other features. \n', 'Full support and privacy\n', '\n', 'Only you will be able to issue it and only you will have all the copyrights!\n', '\n', 'Price is only 0.33 ETH  (if you will gift me a small % of issued coins I will be happy:)).\n', '\n', 'skype open24365\n', '+35796229192 Cyprus\n', 'viber+telegram +375298563585\n', 'viber +375298563585\n', 'telegram +375298563585\n', 'gmail <span class="__cf_email__" data-cfemail="c5b7aaa8a4aba9a4abb6aeaaaf85a2a8a4aca9eba6aaa8">[email&#160;protected]</span>\n', '\n', '\n', '\n', 'the example: https://etherscan.io/address/0x178AbBC1574a55AdA66114Edd68Ab95b690158FC\n', '\n', 'The information I need:\n', '- name for your coin (token)\n', '- short name\n', '- total supply or initial supply\n', '- minable or not (fixed)\n', '- the number of decimals (0.001 = 3 decimals)\n', '- any comments you wanna include in the code (no limits for readme)\n', '\n', 'After send  please  at least 0.25-0.33 ETH to 0x4BCc85fa097ad0f5618cb9bb5bc0AFfbAEC359B5 \n', '\n', 'Adding your coin to EtherDelta exchange, code-verification and github are included  \n', '\n', 'There is no law stronger then the code\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract newToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) balances;\n', '  \n', '\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is newToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '  function approve(address _spender, uint _value) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling approve(_spender, 0) if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract Order is StandardToken, Ownable {\n', '  string public constant name = "Order";\n', '  string public constant symbol = "ETH";\n', '  uint public constant decimals = 3;\n', '  uint256 public initialSupply;\n', '    \n', '  // Constructor\n', '  function Order () { \n', '     totalSupply = 120000 * 10 ** decimals;\n', '      balances[msg.sender] = totalSupply;\n', '      initialSupply = totalSupply; \n', '        Transfer(0, this, totalSupply);\n', '        Transfer(this, msg.sender, totalSupply);\n', '  }\n', '}\n', '\n', 'contract BuyToken is Ownable, Order {\n', '\n', 'uint256 public constant sellPrice = 333 szabo;\n', 'uint256 public constant buyPrice = 333 finney;\n', '\n', '    function buy() payable returns (uint amount)\n', '    {\n', '        amount = msg.value / buyPrice;\n', '        if (balances[this] < amount) throw; \n', '        balances[msg.sender] += amount;\n', '        balances[this] -= amount;\n', '        Transfer(this, msg.sender, amount);\n', '    }\n', '\n', '    function sell(uint256 amount) {\n', '        if (balances[msg.sender] < amount ) throw;\n', '        balances[this] += amount;\n', '        balances[msg.sender] -= amount;\n', '        if (!msg.sender.send(amount * sellPrice)) {\n', '            throw;\n', '        } else {\n', '            Transfer(msg.sender, this, amount);\n', '        }               \n', '    }\n', '    \n', '  function transfer(address _to, uint256 _value) {\n', '        require(balances[msg.sender] > _value);\n', '        require(balances[_to] + _value > balances[_to]);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '   function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '        balances[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '   \n', '    function () payable {\n', '        buy();\n', '    }\n', '}']
['pragma solidity ^0.4.14;\n', '\n', '/* ©RomanLanskoj 2017\n', "I can create the cryptocurrency Ethereum-token for you, with any total or initial supply,  enable the owner to create new tokens or without it,  custom currency rates (can make the token's value be backed by ether (or other tokens) by creating a fund that automatically sells and buys them at market value) and other features. \n", 'Full support and privacy\n', '\n', 'Only you will be able to issue it and only you will have all the copyrights!\n', '\n', 'Price is only 0.33 ETH  (if you will gift me a small % of issued coins I will be happy:)).\n', '\n', 'skype open24365\n', '+35796229192 Cyprus\n', 'viber+telegram +375298563585\n', 'viber +375298563585\n', 'telegram +375298563585\n', 'gmail romanlanskoj@gmail.com\n', '\n', '\n', '\n', 'the example: https://etherscan.io/address/0x178AbBC1574a55AdA66114Edd68Ab95b690158FC\n', '\n', 'The information I need:\n', '- name for your coin (token)\n', '- short name\n', '- total supply or initial supply\n', '- minable or not (fixed)\n', '- the number of decimals (0.001 = 3 decimals)\n', '- any comments you wanna include in the code (no limits for readme)\n', '\n', 'After send  please  at least 0.25-0.33 ETH to 0x4BCc85fa097ad0f5618cb9bb5bc0AFfbAEC359B5 \n', '\n', 'Adding your coin to EtherDelta exchange, code-verification and github are included  \n', '\n', 'There is no law stronger then the code\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract newToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) balances;\n', '  \n', '\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is newToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '  function approve(address _spender, uint _value) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling approve(_spender, 0) if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract Order is StandardToken, Ownable {\n', '  string public constant name = "Order";\n', '  string public constant symbol = "ETH";\n', '  uint public constant decimals = 3;\n', '  uint256 public initialSupply;\n', '    \n', '  // Constructor\n', '  function Order () { \n', '     totalSupply = 120000 * 10 ** decimals;\n', '      balances[msg.sender] = totalSupply;\n', '      initialSupply = totalSupply; \n', '        Transfer(0, this, totalSupply);\n', '        Transfer(this, msg.sender, totalSupply);\n', '  }\n', '}\n', '\n', 'contract BuyToken is Ownable, Order {\n', '\n', 'uint256 public constant sellPrice = 333 szabo;\n', 'uint256 public constant buyPrice = 333 finney;\n', '\n', '    function buy() payable returns (uint amount)\n', '    {\n', '        amount = msg.value / buyPrice;\n', '        if (balances[this] < amount) throw; \n', '        balances[msg.sender] += amount;\n', '        balances[this] -= amount;\n', '        Transfer(this, msg.sender, amount);\n', '    }\n', '\n', '    function sell(uint256 amount) {\n', '        if (balances[msg.sender] < amount ) throw;\n', '        balances[this] += amount;\n', '        balances[msg.sender] -= amount;\n', '        if (!msg.sender.send(amount * sellPrice)) {\n', '            throw;\n', '        } else {\n', '            Transfer(msg.sender, this, amount);\n', '        }               \n', '    }\n', '    \n', '  function transfer(address _to, uint256 _value) {\n', '        require(balances[msg.sender] > _value);\n', '        require(balances[_to] + _value > balances[_to]);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '   function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '        balances[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '   \n', '    function () payable {\n', '        buy();\n', '    }\n', '}']
