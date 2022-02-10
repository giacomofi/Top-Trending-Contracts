['// compiler: 0.4.21+commit.dfe3193c.Emscripten.clang\n', 'pragma solidity ^0.4.21;\n', '\n', '// Ethereum Token callback\n', 'interface tokenRecipient {\n', '  function receiveApproval( address from, uint256 value, bytes data ) external;\n', '}\n', '\n', '// ERC223 callback\n', 'interface ContractReceiver {\n', '  function tokenFallback( address from, uint value, bytes data ) external;\n', '}\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function changeOwner( address _miner ) public onlyOwner {\n', '    owner = _miner;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require (msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '// ERC20 token with added ERC223 and Ethereum-Token support\n', '//\n', '// Blend of multiple interfaces:\n', '// - https://theethereum.wiki/w/index.php/ERC20_Token_Standard\n', '// - https://www.ethereum.org/token (uncontrolled, non-standard)\n', '// - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol\n', '\n', 'contract MineableToken is owned {\n', '\n', '  string  public name;\n', '  string  public symbol;\n', '  uint8   public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  uint256 public supplyCap;\n', '\n', '  mapping( address => uint256 ) balances_;\n', '\n', '  mapping( address => mapping(address => uint256) ) allowances_;\n', '\n', '  // ERC20\n', '  event Approval( address indexed owner,\n', '                  address indexed spender,\n', '                  uint value );\n', '\n', '  // ERC20-compatible version only, breaks ERC223 compliance but etherscan\n', '  // and exchanges only support ERC20 version. Can&#39;t overload events\n', '\n', '  event Transfer( address indexed from,\n', '                  address indexed to,\n', '                  uint256 value );\n', '                  //bytes    data );\n', '\n', '  // Ethereum Token\n', '  event Burn( address indexed from,\n', '              uint256 value );\n', '\n', '  function MineableToken() public {\n', '\n', '    decimals = uint8(18); // audit recommended 18 decimals\n', '    supplyCap = 833333333 * 10**uint256(decimals);\n', '\n', '    name = "ORST";\n', '    symbol = "ORS";\n', '  }\n', '\n', '  function mine( uint256 qty ) public onlyOwner {\n', '    require (    (totalSupply + qty) > totalSupply\n', '              && (totalSupply + qty) <= supplyCap\n', '            );\n', '\n', '    totalSupply += qty;\n', '    balances_[owner] += qty;\n', '    emit Transfer( address(0), owner, qty );\n', '  }\n', '\n', '  function cap() public constant returns(uint256) {\n', '    return supplyCap;\n', '  }\n', '\n', '  // ERC20\n', '  function balanceOf( address owner ) public constant returns (uint) {\n', '    return balances_[owner];\n', '  }\n', '\n', '  // ERC20\n', '  function approve( address spender, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    // WARNING! When changing the approval amount, first set it back to zero\n', '    // AND wait until the transaction is mined. Only afterwards set the new\n', '    // amount. Otherwise you may be prone to a race condition attack.\n', '    // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '    allowances_[msg.sender][spender] = value;\n', '    emit Approval( msg.sender, spender, value );\n', '    return true;\n', '  }\n', ' \n', '  // recommended fix for known attack on any ERC20\n', '  function safeApprove( address _spender,\n', '                        uint256 _currentValue,\n', '                        uint256 _value ) public\n', '  returns (bool success)\n', '  {\n', '    // If current allowance for _spender is equal to _currentValue, then\n', '    // overwrite it with _value and return true, otherwise return false.\n', '\n', '    if (allowances_[msg.sender][_spender] == _currentValue)\n', '      return approve(_spender, _value);\n', '\n', '    return false;\n', '  }\n', '\n', '  // ERC20\n', '  function allowance( address owner, address spender ) public constant\n', '  returns (uint256 remaining)\n', '  {\n', '    return allowances_[owner][spender];\n', '  }\n', '\n', '  // ERC20\n', '  function transfer(address to, uint256 value) public\n', '  {\n', '    bytes memory empty; // null\n', '    _transfer( msg.sender, to, value, empty );\n', '  }\n', '\n', '  // ERC20\n', '  function transferFrom( address from, address to, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    allowances_[from][msg.sender] -= value;\n', '    bytes memory empty;\n', '    _transfer( from, to, value, empty );\n', '\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token\n', '  function approveAndCall( address spender,\n', '                           uint256 value,\n', '                           bytes context ) public\n', '  returns (bool success)\n', '  {\n', '    if ( approve(spender, value) )\n', '    {\n', '      tokenRecipient recip = tokenRecipient( spender );\n', '\n', '      if (isContract(recip))\n', '        recip.receiveApproval( msg.sender, value, context );\n', '\n', '      return true;\n', '    }\n', '\n', '    return false;\n', '  }        \n', '\n', '  // Ethereum Token\n', '  function burn( uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[msg.sender] >= value );\n', '    balances_[msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( msg.sender, value );\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token\n', '  function burnFrom( address from, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[from] >= value );\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    balances_[from] -= value;\n', '    allowances_[from][msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( from, value );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer and invoke specified callback\n', '  function transfer( address to,\n', '                     uint value,\n', '                     bytes data,\n', '                     string custom_fallback ) public returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    // throws if custom_fallback is not a valid contract call\n', '    require( address(to).call.value(0)(bytes4(keccak256(custom_fallback)),\n', '             msg.sender,\n', '             value,\n', '             data) );\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to a contract or externally-owned account\n', '  function transfer( address to, uint value, bytes data ) public\n', '  returns (bool success)\n', '  {\n', '    if (isContract(to)) {\n', '      return transferToContract( to, value, data );\n', '    }\n', '\n', '    _transfer( msg.sender, to, value, data );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to contract and invoke tokenFallback() method\n', '  function transferToContract( address to, uint value, bytes data ) private\n', '  returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    ContractReceiver rx = ContractReceiver(to);\n', '\n', '    if (isContract(rx)) {\n', '      rx.tokenFallback( msg.sender, value, data );\n', '      return true;\n', '    }\n', '\n', '    return false;\n', '  }\n', '\n', '  // ERC223 fetch contract size (must be nonzero to be a contract)\n', '  function isContract( address _addr ) private constant returns (bool)\n', '  {\n', '    uint length;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function _transfer( address from,\n', '                      address to,\n', '                      uint value,\n', '                      bytes data ) internal\n', '  {\n', '    require( to != 0x0 );\n', '    require( balances_[from] >= value );\n', '    require( balances_[to] + value > balances_[to] ); // catch overflow\n', '\n', '    // no transfers allowed before ICO ends 26MAY2018 0900 CET\n', '    if (msg.sender != owner) require( now >= 1527321600 );\n', '\n', '    balances_[from] -= value;\n', '    balances_[to] += value;\n', '\n', '    bytes memory ignore;\n', '    ignore = data;                    // ignore compiler warning\n', '    emit Transfer( from, to, value ); // ignore data\n', '  }\n', '}']
['// compiler: 0.4.21+commit.dfe3193c.Emscripten.clang\n', 'pragma solidity ^0.4.21;\n', '\n', '// Ethereum Token callback\n', 'interface tokenRecipient {\n', '  function receiveApproval( address from, uint256 value, bytes data ) external;\n', '}\n', '\n', '// ERC223 callback\n', 'interface ContractReceiver {\n', '  function tokenFallback( address from, uint value, bytes data ) external;\n', '}\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function changeOwner( address _miner ) public onlyOwner {\n', '    owner = _miner;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require (msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '// ERC20 token with added ERC223 and Ethereum-Token support\n', '//\n', '// Blend of multiple interfaces:\n', '// - https://theethereum.wiki/w/index.php/ERC20_Token_Standard\n', '// - https://www.ethereum.org/token (uncontrolled, non-standard)\n', '// - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol\n', '\n', 'contract MineableToken is owned {\n', '\n', '  string  public name;\n', '  string  public symbol;\n', '  uint8   public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  uint256 public supplyCap;\n', '\n', '  mapping( address => uint256 ) balances_;\n', '\n', '  mapping( address => mapping(address => uint256) ) allowances_;\n', '\n', '  // ERC20\n', '  event Approval( address indexed owner,\n', '                  address indexed spender,\n', '                  uint value );\n', '\n', '  // ERC20-compatible version only, breaks ERC223 compliance but etherscan\n', "  // and exchanges only support ERC20 version. Can't overload events\n", '\n', '  event Transfer( address indexed from,\n', '                  address indexed to,\n', '                  uint256 value );\n', '                  //bytes    data );\n', '\n', '  // Ethereum Token\n', '  event Burn( address indexed from,\n', '              uint256 value );\n', '\n', '  function MineableToken() public {\n', '\n', '    decimals = uint8(18); // audit recommended 18 decimals\n', '    supplyCap = 833333333 * 10**uint256(decimals);\n', '\n', '    name = "ORST";\n', '    symbol = "ORS";\n', '  }\n', '\n', '  function mine( uint256 qty ) public onlyOwner {\n', '    require (    (totalSupply + qty) > totalSupply\n', '              && (totalSupply + qty) <= supplyCap\n', '            );\n', '\n', '    totalSupply += qty;\n', '    balances_[owner] += qty;\n', '    emit Transfer( address(0), owner, qty );\n', '  }\n', '\n', '  function cap() public constant returns(uint256) {\n', '    return supplyCap;\n', '  }\n', '\n', '  // ERC20\n', '  function balanceOf( address owner ) public constant returns (uint) {\n', '    return balances_[owner];\n', '  }\n', '\n', '  // ERC20\n', '  function approve( address spender, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    // WARNING! When changing the approval amount, first set it back to zero\n', '    // AND wait until the transaction is mined. Only afterwards set the new\n', '    // amount. Otherwise you may be prone to a race condition attack.\n', '    // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '    allowances_[msg.sender][spender] = value;\n', '    emit Approval( msg.sender, spender, value );\n', '    return true;\n', '  }\n', ' \n', '  // recommended fix for known attack on any ERC20\n', '  function safeApprove( address _spender,\n', '                        uint256 _currentValue,\n', '                        uint256 _value ) public\n', '  returns (bool success)\n', '  {\n', '    // If current allowance for _spender is equal to _currentValue, then\n', '    // overwrite it with _value and return true, otherwise return false.\n', '\n', '    if (allowances_[msg.sender][_spender] == _currentValue)\n', '      return approve(_spender, _value);\n', '\n', '    return false;\n', '  }\n', '\n', '  // ERC20\n', '  function allowance( address owner, address spender ) public constant\n', '  returns (uint256 remaining)\n', '  {\n', '    return allowances_[owner][spender];\n', '  }\n', '\n', '  // ERC20\n', '  function transfer(address to, uint256 value) public\n', '  {\n', '    bytes memory empty; // null\n', '    _transfer( msg.sender, to, value, empty );\n', '  }\n', '\n', '  // ERC20\n', '  function transferFrom( address from, address to, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    allowances_[from][msg.sender] -= value;\n', '    bytes memory empty;\n', '    _transfer( from, to, value, empty );\n', '\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token\n', '  function approveAndCall( address spender,\n', '                           uint256 value,\n', '                           bytes context ) public\n', '  returns (bool success)\n', '  {\n', '    if ( approve(spender, value) )\n', '    {\n', '      tokenRecipient recip = tokenRecipient( spender );\n', '\n', '      if (isContract(recip))\n', '        recip.receiveApproval( msg.sender, value, context );\n', '\n', '      return true;\n', '    }\n', '\n', '    return false;\n', '  }        \n', '\n', '  // Ethereum Token\n', '  function burn( uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[msg.sender] >= value );\n', '    balances_[msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( msg.sender, value );\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token\n', '  function burnFrom( address from, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[from] >= value );\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    balances_[from] -= value;\n', '    allowances_[from][msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( from, value );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer and invoke specified callback\n', '  function transfer( address to,\n', '                     uint value,\n', '                     bytes data,\n', '                     string custom_fallback ) public returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    // throws if custom_fallback is not a valid contract call\n', '    require( address(to).call.value(0)(bytes4(keccak256(custom_fallback)),\n', '             msg.sender,\n', '             value,\n', '             data) );\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to a contract or externally-owned account\n', '  function transfer( address to, uint value, bytes data ) public\n', '  returns (bool success)\n', '  {\n', '    if (isContract(to)) {\n', '      return transferToContract( to, value, data );\n', '    }\n', '\n', '    _transfer( msg.sender, to, value, data );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to contract and invoke tokenFallback() method\n', '  function transferToContract( address to, uint value, bytes data ) private\n', '  returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    ContractReceiver rx = ContractReceiver(to);\n', '\n', '    if (isContract(rx)) {\n', '      rx.tokenFallback( msg.sender, value, data );\n', '      return true;\n', '    }\n', '\n', '    return false;\n', '  }\n', '\n', '  // ERC223 fetch contract size (must be nonzero to be a contract)\n', '  function isContract( address _addr ) private constant returns (bool)\n', '  {\n', '    uint length;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function _transfer( address from,\n', '                      address to,\n', '                      uint value,\n', '                      bytes data ) internal\n', '  {\n', '    require( to != 0x0 );\n', '    require( balances_[from] >= value );\n', '    require( balances_[to] + value > balances_[to] ); // catch overflow\n', '\n', '    // no transfers allowed before ICO ends 26MAY2018 0900 CET\n', '    if (msg.sender != owner) require( now >= 1527321600 );\n', '\n', '    balances_[from] -= value;\n', '    balances_[to] += value;\n', '\n', '    bytes memory ignore;\n', '    ignore = data;                    // ignore compiler warning\n', '    emit Transfer( from, to, value ); // ignore data\n', '  }\n', '}']
