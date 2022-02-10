['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract ERC20 {\n', '  uint256 public totalSupply = 1000000;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '      if (_value < 0) {\n', '          revert();\n', '      }\n', '      \n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '      \n', '      if (_value < 0) {\n', '          revert();\n', '      }\n', '      \n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract CTest1 is StandardToken {\n', '  \n', '    // Set the contract controller address\n', '    // Set the 3 Founder addresses\n', '    address public owner = msg.sender;\n', '    address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;\n', '    address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;\n', '    address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;\n', '\n', '  \n', '    function name() constant returns (string) { return "CTest1 Token"; }\n', '    function symbol() constant returns (string) { return "CTest1"; }\n', '    function decimals() constant returns (uint) { return 18; }\n', '    \n', '\n', '    \n', '    \n', '    function () payable {\n', '        \n', '        \n', '        //If all the tokens are gone, stop!\n', '        if (totalSupply < 1)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        uint256 rate = 0;\n', '        address receiver = msg.sender;\n', '        \n', '        \n', '        //Set the price to 0.0003 ETH/CTest1\n', '        //$0.10 per\n', '        if (totalSupply > 975000)\n', '        {\n', '            rate = 3340;\n', '        }\n', '        \n', '        //Set the price to 0.0015 ETH/CTest1\n', '        //$0.50 per\n', '        if (totalSupply < 975001)\n', '        {\n', '            rate = 668;\n', '        }\n', '        \n', '        //Set the price to 0.0030 ETH/CTest1\n', '        //$1.00 per\n', '        if (totalSupply < 875001)\n', '        {\n', '            rate = 334;\n', '        }\n', '        \n', '        //Set the price to 0.0075 ETH/CTest1\n', '        //$2.50 per\n', '        if (totalSupply < 475001)\n', '        {\n', '            rate = 134;\n', '        }\n', '        \n', '        \n', '       \n', '\n', '        \n', '        uint256 tokens = (safeMul(msg.value, rate))/1 ether;\n', '        \n', '        \n', '        //Make sure they send enough to buy atleast 1 token.\n', '        if (tokens < 1)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        //Make sure someone isn&#39;t buying more than the remaining supply\n', '        uint256 check = safeSub(totalSupply, tokens);\n', '        if (check < 0)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        //Make sure someone isn&#39;t buying more than the current tier\n', '        if (totalSupply > 975000 && check < 975000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        //Make sure someone isn&#39;t buying more than the current tier\n', '        if (totalSupply > 875000 && check < 875000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        //Make sure someone isn&#39;t buying more than the current tier\n', '        if (totalSupply > 475000 && check < 475000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        //Prevent any ETH address from buying more than 50 CTest1 during the pre-sale\n', '        if ((balances[receiver] + tokens) > 50 && totalSupply > 975000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        balances[receiver] = safeAdd(balances[receiver], tokens);\n', '        \n', '        totalSupply = safeSub(totalSupply, tokens);\n', '        \n', '        Transfer(0, receiver, tokens);\n', '\n', '\n', '\n', '\t    Founder1.transfer((msg.value/3));\t\t\t\t\t//Send the ETH\n', '\t    Founder2.transfer((msg.value/3));\t\t\t\t\t//Send the ETH\n', '\t    Founder3.transfer((msg.value/3));\t\t\t\t\t//Send the ETH\n', '        \n', '    }\n', '    \n', '    \n', '    \n', '    //Burn all remaining tokens.\n', '    //Only contract creator can do this.\n', '    function Burn () {\n', '        \n', '        if (msg.sender == owner && totalSupply > 0)\n', '        {\n', '            totalSupply = 0;\n', '        } else {throw;}\n', '\n', '    }\n', '  \n', '  \n', '  \n', '}']
['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract ERC20 {\n', '  uint256 public totalSupply = 1000000;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '      if (_value < 0) {\n', '          revert();\n', '      }\n', '      \n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '      \n', '      if (_value < 0) {\n', '          revert();\n', '      }\n', '      \n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract CTest1 is StandardToken {\n', '  \n', '    // Set the contract controller address\n', '    // Set the 3 Founder addresses\n', '    address public owner = msg.sender;\n', '    address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;\n', '    address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;\n', '    address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;\n', '\n', '  \n', '    function name() constant returns (string) { return "CTest1 Token"; }\n', '    function symbol() constant returns (string) { return "CTest1"; }\n', '    function decimals() constant returns (uint) { return 18; }\n', '    \n', '\n', '    \n', '    \n', '    function () payable {\n', '        \n', '        \n', '        //If all the tokens are gone, stop!\n', '        if (totalSupply < 1)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        uint256 rate = 0;\n', '        address receiver = msg.sender;\n', '        \n', '        \n', '        //Set the price to 0.0003 ETH/CTest1\n', '        //$0.10 per\n', '        if (totalSupply > 975000)\n', '        {\n', '            rate = 3340;\n', '        }\n', '        \n', '        //Set the price to 0.0015 ETH/CTest1\n', '        //$0.50 per\n', '        if (totalSupply < 975001)\n', '        {\n', '            rate = 668;\n', '        }\n', '        \n', '        //Set the price to 0.0030 ETH/CTest1\n', '        //$1.00 per\n', '        if (totalSupply < 875001)\n', '        {\n', '            rate = 334;\n', '        }\n', '        \n', '        //Set the price to 0.0075 ETH/CTest1\n', '        //$2.50 per\n', '        if (totalSupply < 475001)\n', '        {\n', '            rate = 134;\n', '        }\n', '        \n', '        \n', '       \n', '\n', '        \n', '        uint256 tokens = (safeMul(msg.value, rate))/1 ether;\n', '        \n', '        \n', '        //Make sure they send enough to buy atleast 1 token.\n', '        if (tokens < 1)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', "        //Make sure someone isn't buying more than the remaining supply\n", '        uint256 check = safeSub(totalSupply, tokens);\n', '        if (check < 0)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', "        //Make sure someone isn't buying more than the current tier\n", '        if (totalSupply > 975000 && check < 975000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', "        //Make sure someone isn't buying more than the current tier\n", '        if (totalSupply > 875000 && check < 875000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', "        //Make sure someone isn't buying more than the current tier\n", '        if (totalSupply > 475000 && check < 475000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        //Prevent any ETH address from buying more than 50 CTest1 during the pre-sale\n', '        if ((balances[receiver] + tokens) > 50 && totalSupply > 975000)\n', '        {\n', '            throw;\n', '        }\n', '        \n', '        \n', '        balances[receiver] = safeAdd(balances[receiver], tokens);\n', '        \n', '        totalSupply = safeSub(totalSupply, tokens);\n', '        \n', '        Transfer(0, receiver, tokens);\n', '\n', '\n', '\n', '\t    Founder1.transfer((msg.value/3));\t\t\t\t\t//Send the ETH\n', '\t    Founder2.transfer((msg.value/3));\t\t\t\t\t//Send the ETH\n', '\t    Founder3.transfer((msg.value/3));\t\t\t\t\t//Send the ETH\n', '        \n', '    }\n', '    \n', '    \n', '    \n', '    //Burn all remaining tokens.\n', '    //Only contract creator can do this.\n', '    function Burn () {\n', '        \n', '        if (msg.sender == owner && totalSupply > 0)\n', '        {\n', '            totalSupply = 0;\n', '        } else {throw;}\n', '\n', '    }\n', '  \n', '  \n', '  \n', '}']