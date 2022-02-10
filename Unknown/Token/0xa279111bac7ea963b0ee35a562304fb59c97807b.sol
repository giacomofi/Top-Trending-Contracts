['pragma solidity ^0.4.13;\n', '\n', ' /// @title Ownable contract - base contract with an owner\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a7c3c2d1e7d4cac6d5d3c4c8c9d3d5c6c4d3c2c6ca89c4c8ca">[email&#160;protected]</a>\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);  \n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', ' /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="bcd8d9cafccfd1ddcec8dfd3d2c8cedddfc8d9ddd192dfd3d1">[email&#160;protected]</a>\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function mint(address receiver, uint amount);\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', ' /// @title SafeMath contract - math operations with safety checks\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b2d6d7c4f2c1dfd3c0c6d1dddcc6c0d3d1c6d7d3df9cd1dddf">[email&#160;protected]</a>\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    require(assertion);  \n', '  }\n', '}\n', '\n', '/// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', '/// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="096d6c7f497a64687b7d6a66677d7b686a7d6c6864276a6664">[email&#160;protected]</a>\n', 'contract ZiberToken is SafeMath, ERC20, Ownable {\n', ' string public name = "Ziber Token";\n', ' string public symbol = "ZBR";\n', ' uint public decimals = 8;\n', ' uint public constant FROZEN_TOKENS = 10000000;\n', ' uint public constant FREEZE_PERIOD = 1 years;\n', ' uint public crowdSaleOverTimestamp;\n', '\n', ' /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token\n', ' address public crowdsaleAgent;\n', ' /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.\n', ' bool public released = false;\n', ' /// approve() allowances\n', ' mapping (address => mapping (address => uint)) allowed;\n', ' /// holder balances\n', ' mapping(address => uint) balances;\n', '\n', ' /// @dev Limit token transfer until the crowdsale is over.\n', ' modifier canTransfer() {\n', '   if(!released) {\n', '     require(msg.sender == crowdsaleAgent);\n', '   }\n', '   _;\n', ' }\n', '\n', ' modifier checkFrozenAmount(address source, uint amount) {\n', '   if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {\n', '     var frozenTokens = 10 ** decimals * FROZEN_TOKENS;\n', '     require(safeSub(balances[owner], amount) > frozenTokens);\n', '   }\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only before or after the tokens have been releasesd\n', ' /// @param _released token transfer and mint state\n', ' modifier inReleaseState(bool _released) {\n', '   require(_released == released);\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only by release agent.\n', ' modifier onlyCrowdsaleAgent() {\n', '   require(msg.sender == crowdsaleAgent);\n', '   _;\n', ' }\n', '\n', ' /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/\n', ' /// @param size payload size\n', ' modifier onlyPayloadSize(uint size) {\n', '   require(msg.data.length >= size + 4);\n', '    _;\n', ' }\n', '\n', ' /// @dev Make sure we are not done yet.\n', ' modifier canMint() {\n', '   require(!released);\n', '    _;\n', '  }\n', '\n', ' /// @dev Constructor\n', ' function ZiberToken() {\n', '   owner = msg.sender;\n', ' }\n', '\n', ' /// Fallback method will buyout tokens\n', ' function() payable {\n', '   revert();\n', ' }\n', ' /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract\n', ' /// @param receiver Address of receiver\n', ' /// @param amount  Number of tokens to issue.\n', ' function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '    balances[receiver] = safeAdd(balances[receiver], amount);\n', '    Transfer(0, receiver, amount);\n', ' }\n', '\n', ' /// @dev Set the contract that can call release and make the token transferable.\n', ' /// @param _crowdsaleAgent crowdsale contract address\n', ' function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {\n', '   crowdsaleAgent = _crowdsaleAgent;\n', ' }\n', ' /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', ' function releaseTokenTransfer() public onlyCrowdsaleAgent {\n', '   crowdSaleOverTimestamp = now;\n', '   released = true;\n', ' }\n', ' /// @dev Tranfer tokens to address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {\n', '   balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '   balances[_to] = safeAdd(balances[_to], _value);\n', '\n', '   Transfer(msg.sender, _to, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Tranfer tokens from one address to other\n', ' /// @param _from source address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', ' }\n', ' /// @dev Tokens balance\n', ' /// @param _owner holder address\n', ' /// @return balance amount\n', ' function balanceOf(address _owner) constant returns (uint balance) {\n', '   return balances[_owner];\n', ' }\n', '\n', ' /// @dev Approve transfer\n', ' /// @param _spender holder address\n', ' /// @param _value tokens amount\n', ' /// @return result\n', ' function approve(address _spender, uint _value) returns (bool success) {\n', '   // To change the approve amount you first have to reduce the addresses`\n', '   //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '   //  already 0 to mitigate the race condition described here:\n', '   //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729   \n', '   require ((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '   allowed[msg.sender][_spender] = _value;\n', '   Approval(msg.sender, _spender, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Token allowance\n', ' /// @param _owner holder address\n', ' /// @param _spender spender address\n', ' /// @return remain amount\n', ' function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '   return allowed[_owner][_spender];\n', ' }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', ' /// @title Ownable contract - base contract with an owner\n', ' /// @author dev@smartcontracteam.com\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);  \n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', ' /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20\n', ' /// @author dev@smartcontracteam.com\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function mint(address receiver, uint amount);\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', ' /// @title SafeMath contract - math operations with safety checks\n', ' /// @author dev@smartcontracteam.com\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    require(assertion);  \n', '  }\n', '}\n', '\n', '/// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', '/// @author dev@smartcontracteam.com\n', 'contract ZiberToken is SafeMath, ERC20, Ownable {\n', ' string public name = "Ziber Token";\n', ' string public symbol = "ZBR";\n', ' uint public decimals = 8;\n', ' uint public constant FROZEN_TOKENS = 10000000;\n', ' uint public constant FREEZE_PERIOD = 1 years;\n', ' uint public crowdSaleOverTimestamp;\n', '\n', ' /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token\n', ' address public crowdsaleAgent;\n', ' /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.\n', ' bool public released = false;\n', ' /// approve() allowances\n', ' mapping (address => mapping (address => uint)) allowed;\n', ' /// holder balances\n', ' mapping(address => uint) balances;\n', '\n', ' /// @dev Limit token transfer until the crowdsale is over.\n', ' modifier canTransfer() {\n', '   if(!released) {\n', '     require(msg.sender == crowdsaleAgent);\n', '   }\n', '   _;\n', ' }\n', '\n', ' modifier checkFrozenAmount(address source, uint amount) {\n', '   if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {\n', '     var frozenTokens = 10 ** decimals * FROZEN_TOKENS;\n', '     require(safeSub(balances[owner], amount) > frozenTokens);\n', '   }\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only before or after the tokens have been releasesd\n', ' /// @param _released token transfer and mint state\n', ' modifier inReleaseState(bool _released) {\n', '   require(_released == released);\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only by release agent.\n', ' modifier onlyCrowdsaleAgent() {\n', '   require(msg.sender == crowdsaleAgent);\n', '   _;\n', ' }\n', '\n', ' /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/\n', ' /// @param size payload size\n', ' modifier onlyPayloadSize(uint size) {\n', '   require(msg.data.length >= size + 4);\n', '    _;\n', ' }\n', '\n', ' /// @dev Make sure we are not done yet.\n', ' modifier canMint() {\n', '   require(!released);\n', '    _;\n', '  }\n', '\n', ' /// @dev Constructor\n', ' function ZiberToken() {\n', '   owner = msg.sender;\n', ' }\n', '\n', ' /// Fallback method will buyout tokens\n', ' function() payable {\n', '   revert();\n', ' }\n', ' /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract\n', ' /// @param receiver Address of receiver\n', ' /// @param amount  Number of tokens to issue.\n', ' function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '    balances[receiver] = safeAdd(balances[receiver], amount);\n', '    Transfer(0, receiver, amount);\n', ' }\n', '\n', ' /// @dev Set the contract that can call release and make the token transferable.\n', ' /// @param _crowdsaleAgent crowdsale contract address\n', ' function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {\n', '   crowdsaleAgent = _crowdsaleAgent;\n', ' }\n', ' /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', ' function releaseTokenTransfer() public onlyCrowdsaleAgent {\n', '   crowdSaleOverTimestamp = now;\n', '   released = true;\n', ' }\n', ' /// @dev Tranfer tokens to address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {\n', '   balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '   balances[_to] = safeAdd(balances[_to], _value);\n', '\n', '   Transfer(msg.sender, _to, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Tranfer tokens from one address to other\n', ' /// @param _from source address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', ' }\n', ' /// @dev Tokens balance\n', ' /// @param _owner holder address\n', ' /// @return balance amount\n', ' function balanceOf(address _owner) constant returns (uint balance) {\n', '   return balances[_owner];\n', ' }\n', '\n', ' /// @dev Approve transfer\n', ' /// @param _spender holder address\n', ' /// @param _value tokens amount\n', ' /// @return result\n', ' function approve(address _spender, uint _value) returns (bool success) {\n', '   // To change the approve amount you first have to reduce the addresses`\n', '   //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '   //  already 0 to mitigate the race condition described here:\n', '   //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729   \n', '   require ((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '   allowed[msg.sender][_spender] = _value;\n', '   Approval(msg.sender, _spender, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Token allowance\n', ' /// @param _owner holder address\n', ' /// @param _spender spender address\n', ' /// @return remain amount\n', ' function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '   return allowed[_owner][_spender];\n', ' }\n', '}']
