['pragma solidity ^0.4.4;\n', '\n', 'contract DNCAsset {\n', '    uint256 public totalSupply = 0;\n', '    //function balanceOf(address who) constant returns (uint);\n', '    //function transfer(address _to, uint _value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', ' \n', 'contract DNCReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', '/* SafeMath for checking eror*/\n', 'library SafeMath {\n', '    \n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '\n', '}\n', '\n', 'contract ERC223BasicToken is DNCAsset{\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            DNCReceivingContract receiver = DNCReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract DNCEQUITY is ERC223BasicToken{\n', '\taddress admin;\n', '\tstring public name = "DinarCoin";\n', '    string public symbol = "DNC";\n', '    uint public decimals = 18;\n', '\tmapping (address => bool) public mintable;\n', '\n', '\tevent Minted(address indexed recipient, uint256 value);\n', '\tevent Burned(address indexed user, uint256 value);\n', '\n', '\tfunction DNCEQUITY() {\n', '\t\tadmin = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyadmin { if (msg.sender == admin) _; }\n', '\n', '\tfunction changeAdmin(address _newAdminAddr) onlyadmin {\n', '\t\tadmin = _newAdminAddr;\n', '\t}\n', '\n', '\tfunction createNewMintableUser (address newAddr) onlyadmin {\n', '\t\tif(balances[newAddr] == 0)  \n', '    \t\tmintable[newAddr] = true;\n', '\t}\n', '\t\n', '\tfunction deleteMintable (address addr) onlyadmin {\n', '\t    mintable[addr] = false;\n', '\t}\n', '\t\n', '\tfunction adminTransfer(address from, address to, uint256 value) onlyadmin {\n', '        if(mintable[from] == true) {\n', '    \t    balances[from] = balances[from].sub(value);\n', '    \t    balances[to] = balances[to].add(value);\n', '    \t    Transfer(from, to, value);\n', '        }\n', '\t}\n', '\t\n', '\tfunction mintNewDNC(address user, uint256 quantity) onlyadmin {\n', '\t    uint256 correctedQuantity = quantity * (10**(decimals-1));\n', '        if(mintable[user] == true) {\n', '            totalSupply = totalSupply.add(correctedQuantity);\n', '            balances[user] = balances[user].add(correctedQuantity);\n', '            Transfer(0, user, correctedQuantity);\n', '            Minted(user, correctedQuantity);\n', '        }   \n', '\t}\n', '\t\n', '\tfunction burnDNC(address user, uint256 quantity) onlyadmin {\n', '\t    uint256 correctedQuantity = quantity * (10**(decimals-1));\n', '\t    if(mintable[user] == true) {\n', '            balances[user] = balances[user].sub(correctedQuantity);\n', '            totalSupply = totalSupply.sub(correctedQuantity);\n', '            Transfer(user, 0, correctedQuantity);\n', '            Burned(user, correctedQuantity);\n', '\t    }\n', '\t}\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract DNCAsset {\n', '    uint256 public totalSupply = 0;\n', '    //function balanceOf(address who) constant returns (uint);\n', '    //function transfer(address _to, uint _value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', ' \n', 'contract DNCReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', '/* SafeMath for checking eror*/\n', 'library SafeMath {\n', '    \n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '\n', '}\n', '\n', 'contract ERC223BasicToken is DNCAsset{\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            DNCReceivingContract receiver = DNCReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract DNCEQUITY is ERC223BasicToken{\n', '\taddress admin;\n', '\tstring public name = "DinarCoin";\n', '    string public symbol = "DNC";\n', '    uint public decimals = 18;\n', '\tmapping (address => bool) public mintable;\n', '\n', '\tevent Minted(address indexed recipient, uint256 value);\n', '\tevent Burned(address indexed user, uint256 value);\n', '\n', '\tfunction DNCEQUITY() {\n', '\t\tadmin = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyadmin { if (msg.sender == admin) _; }\n', '\n', '\tfunction changeAdmin(address _newAdminAddr) onlyadmin {\n', '\t\tadmin = _newAdminAddr;\n', '\t}\n', '\n', '\tfunction createNewMintableUser (address newAddr) onlyadmin {\n', '\t\tif(balances[newAddr] == 0)  \n', '    \t\tmintable[newAddr] = true;\n', '\t}\n', '\t\n', '\tfunction deleteMintable (address addr) onlyadmin {\n', '\t    mintable[addr] = false;\n', '\t}\n', '\t\n', '\tfunction adminTransfer(address from, address to, uint256 value) onlyadmin {\n', '        if(mintable[from] == true) {\n', '    \t    balances[from] = balances[from].sub(value);\n', '    \t    balances[to] = balances[to].add(value);\n', '    \t    Transfer(from, to, value);\n', '        }\n', '\t}\n', '\t\n', '\tfunction mintNewDNC(address user, uint256 quantity) onlyadmin {\n', '\t    uint256 correctedQuantity = quantity * (10**(decimals-1));\n', '        if(mintable[user] == true) {\n', '            totalSupply = totalSupply.add(correctedQuantity);\n', '            balances[user] = balances[user].add(correctedQuantity);\n', '            Transfer(0, user, correctedQuantity);\n', '            Minted(user, correctedQuantity);\n', '        }   \n', '\t}\n', '\t\n', '\tfunction burnDNC(address user, uint256 quantity) onlyadmin {\n', '\t    uint256 correctedQuantity = quantity * (10**(decimals-1));\n', '\t    if(mintable[user] == true) {\n', '            balances[user] = balances[user].sub(correctedQuantity);\n', '            totalSupply = totalSupply.sub(correctedQuantity);\n', '            Transfer(user, 0, correctedQuantity);\n', '            Burned(user, correctedQuantity);\n', '\t    }\n', '\t}\n', '}']
