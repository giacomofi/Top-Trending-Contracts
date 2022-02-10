['// compiler: 0.4.21+commit.dfe3193c.Emscripten.clang\n', 'pragma solidity ^0.4.21;\n', '\n', '// https://www.ethereum.org/token\n', 'interface tokenRecipient {\n', '  function receiveApproval( address from, uint256 value, bytes data ) external;\n', '}\n', '\n', '// ERC223 - LLT Luxury Lifestyle Token Intel-wise Edition - RS\n', '// ERC20 token with added ERC223 and Ethereum-Token support\n', '\n', '// Combination of multiple interfaces:\n', '// https://theethereum.wiki/w/index.php/ERC20_Token_Standard\n', '// https://www.ethereum.org/token (uncontrolled, non-standard)\n', '// https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol\n', '\n', 'interface ContractReceiver {\n', '  function tokenFallback( address from, uint value, bytes data ) external;\n', '}\n', '\n', 'contract ERC223Token\n', '{\n', '  string  public name;\n', '  string  public symbol;\n', '  uint8   public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  mapping( address => uint256 ) balances_;\n', '  mapping( address => mapping(address => uint256) ) allowances_;\n', '\n', '  // ERC20\n', '  event Approval( address indexed owner,\n', '                  address indexed spender,\n', '                  uint value );\n', '\n', '  event Transfer( address indexed from,\n', '                  address indexed to,\n', '                  uint256 value );\n', '               // bytes    data ); use ERC20 version instead\n', '\n', '  // Ethereum Token\n', '  event Burn( address indexed from, uint256 value );\n', '\n', '  constructor( uint256 initialSupply,\n', '                        string tokenName,\n', '                        uint8 decimalUnits,\n', '                        string tokenSymbol ) public\n', '  {\n', '    totalSupply = initialSupply * 10 ** uint256(decimalUnits);\n', '    balances_[msg.sender] = totalSupply;\n', '    name = tokenName;\n', '    decimals = decimalUnits;\n', '    symbol = tokenSymbol;\n', '    emit Transfer( address(0), msg.sender, totalSupply );\n', '  }\n', '\n', '  function() public payable { revert(); } // does not accept money\n', '\n', '  // ERC20\n', '  function balanceOf( address owner ) public constant returns (uint) {\n', '    return balances_[owner];\n', '  }\n', '\n', '  // ERC20\n', '  //\n', '  // WARNING! When changing the approval amount, first set it back to zero\n', '  // AND wait until the transaction is mined. Only afterwards set the new\n', '  // amount. Otherwise you may be prone to a race condition attack.\n', '  // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '  function approve( address spender, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    allowances_[msg.sender][spender] = value;\n', '    emit Approval( msg.sender, spender, value );\n', '    return true;\n', '  }\n', ' \n', '  // recommended fix for known attack on any ERC20\n', '  function safeApprove( address _spender,\n', '                        uint256 _currentValue,\n', '                        uint256 _value ) public\n', '                        returns (bool success) {\n', '\n', '    // If current allowance for _spender is equal to _currentValue, then\n', '    // overwrite it with _value and return true, otherwise return false.\n', '\n', '    if (allowances_[msg.sender][_spender] == _currentValue)\n', '      return approve(_spender, _value);\n', '\n', '    return false;\n', '  }\n', '\n', '  // ERC20\n', '  function allowance( address owner, address spender ) public constant\n', '  returns (uint256 remaining)\n', '  {\n', '    return allowances_[owner][spender];\n', '  }\n', '\n', '  // ERC20\n', '  function transfer(address to, uint256 value) public returns (bool success)\n', '  {\n', '    bytes memory empty; // null\n', '    _transfer( msg.sender, to, value, empty );\n', '    return true;\n', '  }\n', '\n', '  // ERC20\n', '  function transferFrom( address from, address to, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    allowances_[from][msg.sender] -= value;\n', '    bytes memory empty;\n', '    _transfer( from, to, value, empty );\n', '\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token Definition\n', '  function approveAndCall( address spender,\n', '                           uint256 value,\n', '                           bytes context ) public\n', '  returns (bool success)\n', '  {\n', '    if ( approve(spender, value) )\n', '    {\n', '      tokenRecipient recip = tokenRecipient( spender );\n', '      recip.receiveApproval( msg.sender, value, context );\n', '      return true;\n', '    }\n', '    return false;\n', '  }        \n', '\n', '  // Ethereum Token\n', '  function burn( uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[msg.sender] >= value );\n', '    balances_[msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( msg.sender, value );\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token\n', '  function burnFrom( address from, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[from] >= value );\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    balances_[from] -= value;\n', '    allowances_[from][msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( from, value );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer and invoke specified callback\n', '  function transfer( address to,\n', '                     uint value,\n', '                     bytes data,\n', '                     string custom_fallback ) public returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    if ( isContract(to) )\n', '    {\n', '      ContractReceiver rx = ContractReceiver( to );\n', '      require( address(rx).call.value(0)(bytes4(keccak256(abi.encodePacked(custom_fallback))),\n', '               msg.sender,\n', '               value,\n', '               data) );\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to a contract or externally-owned account\n', '  function transfer( address to, uint value, bytes data ) public\n', '  returns (bool success)\n', '  {\n', '    if (isContract(to)) {\n', '      return transferToContract( to, value, data );\n', '    }\n', '\n', '    _transfer( msg.sender, to, value, data );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to contract and invoke tokenFallback() method\n', '  function transferToContract( address to, uint value, bytes data ) private\n', '  returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    ContractReceiver rx = ContractReceiver(to);\n', '    rx.tokenFallback( msg.sender, value, data );\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Fetch contract size (This must be non-zero to be a contract)\n', '  function isContract( address _addr ) private constant returns (bool)\n', '  {\n', '    uint length;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function _transfer( address from,\n', '                      address to,\n', '                      uint value,\n', '                      bytes data ) internal\n', '  {\n', '    require( to != 0x0 );\n', '    require( balances_[from] >= value );\n', '    require( balances_[to] + value > balances_[to] ); // catch overflow\n', '\n', '    balances_[from] -= value;\n', '    balances_[to] += value;\n', '\n', '    //Transfer( from, to, value, data ); This is the ERC223 compatible version\n', '    bytes memory empty;\n', '    empty = data;\n', '    emit Transfer( from, to, value ); // This is the ERC20 compatible version\n', '  }\n', '}']
['// compiler: 0.4.21+commit.dfe3193c.Emscripten.clang\n', 'pragma solidity ^0.4.21;\n', '\n', '// https://www.ethereum.org/token\n', 'interface tokenRecipient {\n', '  function receiveApproval( address from, uint256 value, bytes data ) external;\n', '}\n', '\n', '// ERC223 - LLT Luxury Lifestyle Token Intel-wise Edition - RS\n', '// ERC20 token with added ERC223 and Ethereum-Token support\n', '\n', '// Combination of multiple interfaces:\n', '// https://theethereum.wiki/w/index.php/ERC20_Token_Standard\n', '// https://www.ethereum.org/token (uncontrolled, non-standard)\n', '// https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol\n', '\n', 'interface ContractReceiver {\n', '  function tokenFallback( address from, uint value, bytes data ) external;\n', '}\n', '\n', 'contract ERC223Token\n', '{\n', '  string  public name;\n', '  string  public symbol;\n', '  uint8   public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  mapping( address => uint256 ) balances_;\n', '  mapping( address => mapping(address => uint256) ) allowances_;\n', '\n', '  // ERC20\n', '  event Approval( address indexed owner,\n', '                  address indexed spender,\n', '                  uint value );\n', '\n', '  event Transfer( address indexed from,\n', '                  address indexed to,\n', '                  uint256 value );\n', '               // bytes    data ); use ERC20 version instead\n', '\n', '  // Ethereum Token\n', '  event Burn( address indexed from, uint256 value );\n', '\n', '  constructor( uint256 initialSupply,\n', '                        string tokenName,\n', '                        uint8 decimalUnits,\n', '                        string tokenSymbol ) public\n', '  {\n', '    totalSupply = initialSupply * 10 ** uint256(decimalUnits);\n', '    balances_[msg.sender] = totalSupply;\n', '    name = tokenName;\n', '    decimals = decimalUnits;\n', '    symbol = tokenSymbol;\n', '    emit Transfer( address(0), msg.sender, totalSupply );\n', '  }\n', '\n', '  function() public payable { revert(); } // does not accept money\n', '\n', '  // ERC20\n', '  function balanceOf( address owner ) public constant returns (uint) {\n', '    return balances_[owner];\n', '  }\n', '\n', '  // ERC20\n', '  //\n', '  // WARNING! When changing the approval amount, first set it back to zero\n', '  // AND wait until the transaction is mined. Only afterwards set the new\n', '  // amount. Otherwise you may be prone to a race condition attack.\n', '  // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '  function approve( address spender, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    allowances_[msg.sender][spender] = value;\n', '    emit Approval( msg.sender, spender, value );\n', '    return true;\n', '  }\n', ' \n', '  // recommended fix for known attack on any ERC20\n', '  function safeApprove( address _spender,\n', '                        uint256 _currentValue,\n', '                        uint256 _value ) public\n', '                        returns (bool success) {\n', '\n', '    // If current allowance for _spender is equal to _currentValue, then\n', '    // overwrite it with _value and return true, otherwise return false.\n', '\n', '    if (allowances_[msg.sender][_spender] == _currentValue)\n', '      return approve(_spender, _value);\n', '\n', '    return false;\n', '  }\n', '\n', '  // ERC20\n', '  function allowance( address owner, address spender ) public constant\n', '  returns (uint256 remaining)\n', '  {\n', '    return allowances_[owner][spender];\n', '  }\n', '\n', '  // ERC20\n', '  function transfer(address to, uint256 value) public returns (bool success)\n', '  {\n', '    bytes memory empty; // null\n', '    _transfer( msg.sender, to, value, empty );\n', '    return true;\n', '  }\n', '\n', '  // ERC20\n', '  function transferFrom( address from, address to, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    allowances_[from][msg.sender] -= value;\n', '    bytes memory empty;\n', '    _transfer( from, to, value, empty );\n', '\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token Definition\n', '  function approveAndCall( address spender,\n', '                           uint256 value,\n', '                           bytes context ) public\n', '  returns (bool success)\n', '  {\n', '    if ( approve(spender, value) )\n', '    {\n', '      tokenRecipient recip = tokenRecipient( spender );\n', '      recip.receiveApproval( msg.sender, value, context );\n', '      return true;\n', '    }\n', '    return false;\n', '  }        \n', '\n', '  // Ethereum Token\n', '  function burn( uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[msg.sender] >= value );\n', '    balances_[msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( msg.sender, value );\n', '    return true;\n', '  }\n', '\n', '  // Ethereum Token\n', '  function burnFrom( address from, uint256 value ) public\n', '  returns (bool success)\n', '  {\n', '    require( balances_[from] >= value );\n', '    require( value <= allowances_[from][msg.sender] );\n', '\n', '    balances_[from] -= value;\n', '    allowances_[from][msg.sender] -= value;\n', '    totalSupply -= value;\n', '\n', '    emit Burn( from, value );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer and invoke specified callback\n', '  function transfer( address to,\n', '                     uint value,\n', '                     bytes data,\n', '                     string custom_fallback ) public returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    if ( isContract(to) )\n', '    {\n', '      ContractReceiver rx = ContractReceiver( to );\n', '      require( address(rx).call.value(0)(bytes4(keccak256(abi.encodePacked(custom_fallback))),\n', '               msg.sender,\n', '               value,\n', '               data) );\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to a contract or externally-owned account\n', '  function transfer( address to, uint value, bytes data ) public\n', '  returns (bool success)\n', '  {\n', '    if (isContract(to)) {\n', '      return transferToContract( to, value, data );\n', '    }\n', '\n', '    _transfer( msg.sender, to, value, data );\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Transfer to contract and invoke tokenFallback() method\n', '  function transferToContract( address to, uint value, bytes data ) private\n', '  returns (bool success)\n', '  {\n', '    _transfer( msg.sender, to, value, data );\n', '\n', '    ContractReceiver rx = ContractReceiver(to);\n', '    rx.tokenFallback( msg.sender, value, data );\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 Fetch contract size (This must be non-zero to be a contract)\n', '  function isContract( address _addr ) private constant returns (bool)\n', '  {\n', '    uint length;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function _transfer( address from,\n', '                      address to,\n', '                      uint value,\n', '                      bytes data ) internal\n', '  {\n', '    require( to != 0x0 );\n', '    require( balances_[from] >= value );\n', '    require( balances_[to] + value > balances_[to] ); // catch overflow\n', '\n', '    balances_[from] -= value;\n', '    balances_[to] += value;\n', '\n', '    //Transfer( from, to, value, data ); This is the ERC223 compatible version\n', '    bytes memory empty;\n', '    empty = data;\n', '    emit Transfer( from, to, value ); // This is the ERC20 compatible version\n', '  }\n', '}']
